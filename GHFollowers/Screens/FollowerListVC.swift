//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Christian Diaz on 6/28/22.
//

import UIKit

class FollowerListVC: UIViewController {
    
    enum Section {
        case main
    }
    
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var username: String!
    var page = 1
    var hasMoreFollowers = true
    var isSearching = false
    var isLoadingMoreFollowers = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureCollectionView()
        configureDataSource()
        getFollowers(username: username, page: page)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    deinit {
        //print("follower VC deinitialized")
    }
    
// MARK: - Network Call
    
    func getFollowers(username: String, page: Int) {
        showLoadingView()
        isLoadingMoreFollowers = true
        
        NetworkManager.shared.downloadFollowers(for: username, page: page) { [weak self] result in
            guard let self = self else {return}
            self.dismissLoadingView()
            
            switch result {
            case .success(let followers):
                // The user will not have any additional followers if the last downloaded page pulled less than 100 followers
                if followers.count < 100 {
                    self.hasMoreFollowers = false
                }
                self.followers.append(contentsOf: followers)
                
                // If the user doesn't have any followers, an empty state view will appear
                if self.followers.isEmpty {
                    let message = "This user doesn't have any followers. Go follow them 😁"
                    DispatchQueue.main.async {
                        self.showEmptyStateView(with: message)
                    }
                    return
                }
                // Begins to dispaly the collection view once the data has been successfully retrived
                self.updateData(on: self.followers)
                
            case .failure(let errorMessage):
                self.presentGFAlertOnMainThread(title: "Bad stuff Happened", message: errorMessage.rawValue, buttonTitle: "Ok")
            }
            self.isLoadingMoreFollowers = false
        }
    }
    
// MARK: - UI Configuration & Layout
        
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addButtonTapped() {
        showLoadingView()
        
        NetworkManager.shared.downloadUser(for: username) { [weak self] result in
            guard let self = self else {return}
            self.dismissLoadingView()
            
            switch result {
            case .success(let user):
                let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
                
                PersistanceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
                    guard let self = self else {return}
                    
                    guard let error = error else {
                        self.presentGFAlertOnMainThread(title: "Success!", message: "\(user.login) has been added to your favorites list", buttonTitle: "Ok")
                        return
                    }
                    self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
                }
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a user"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: self.view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    // Function that connects a diffable data source to our collection view
    func configureDataSource() {
        // dataSource's cellprovider closure is called for eaach cell displayed on the UI
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower in
            // Configures our collection view with a Follower Cell. The follower cell defines how to display the cell on the UI.
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            // This is where the cell downloads the user icons 
            cell.set(follower: follower)
            return cell
        })
        
    }
    
    func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        // Feeds data to a snapshot that will be applied to the diffable data source
        snapshot.appendSections([.main])
        snapshot.appendItems(followers, toSection: .main)
        DispatchQueue.main.async {
            // Applies the data, calls dataSource's closure for each cell and displays the results to the UI
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

// MARK: - Extensions

extension FollowerListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        // When the user scrolls down, downloads the next page of followers if there are any, and also if followers aren't currently downloading
        if offsetY > contentHeight - height {
            guard hasMoreFollowers, !isLoadingMoreFollowers else {return}
            page += 1
            getFollowers(username: username, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]
        
        let destVC = UserInfoVC()
        destVC.username = follower.login
        destVC.delegate = self
        
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }
}

extension FollowerListVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        // Dynamically captures a string that the user inputs
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
            return
        }
        isSearching = true
        // Filters out the followers array based on the filter string
        filteredFollowers = followers.filter {$0.login.lowercased().contains(filter.lowercased())}
        updateData(on: filteredFollowers)
    }
}

// Tells the delegate (User Info VC) what to do when it requests a follower list of a user
extension FollowerListVC: UserInfoVCDelegate {
    
    func didRequestFollowers(for username: String) {
        let usersFollowersVC = FollowerListVC(username: username)
        
        navigationController?.pushViewController(usersFollowersVC, animated: true)
    
    }
}
