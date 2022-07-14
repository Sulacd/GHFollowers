//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Christian Diaz on 7/10/22.
//

import UIKit

class UserInfoVC: UIViewController {
        
    // Container views
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    
    var itemViews: [UIView] = []
    
    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        layoutUI()
        getUserInfo()
        
    }
    
// MARK: - Network Call & Child View Controllers
    
    func getUserInfo() {
        NetworkManager.shared.downloadUser(for: username) { [weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
                    self.add(childVC: GFRepoItemVC(user: user), to: self.itemViewOne)
                    self.add(childVC: GFFollowerItemVC(user: user), to: self.itemViewTwo)
                }
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    // Function that adds a Child VC's view to a container view as well as establishing a relation to the parent view
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }

// MARK: - UI Layout & Configuration
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func layoutUI() {
        itemViews = [headerView, itemViewOne, itemViewTwo]
        
        let padding: CGFloat = 20
        
        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        }
        
        let itemHeight: CGFloat = 140
    
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight)
        ])
    }
    
}
