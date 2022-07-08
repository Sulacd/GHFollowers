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
    
    var username: String!
    var followers: [Follower] = []
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        configureDataSource()
        getFollowers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func getFollowers() {
        NetworkManager.shared.getFollowers(for: username, page: 1) { [weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .success(let followers):
                self.followers = followers
                self.updateData()
            case .failure(let errorMessage):
                self.presentGFAlertOnMainThread(title: "Bad stuff Happened", message: errorMessage.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
        
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: self.view))
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    // Function that connects a diffable data source to our collection view
    func configureDataSource() {
        // dataSource's cellprovider closure is called for eaach cell displayed on the UI
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower in
            // Configures our collection view with a Follower Cell. The follower cell defines how to display the cell on the UI.
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    func updateData() {
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
