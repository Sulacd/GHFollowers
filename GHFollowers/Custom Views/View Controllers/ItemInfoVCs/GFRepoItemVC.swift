//
//  GFRepoItemVC.swift
//  GHFollowers
//
//  Created by Christian Diaz on 7/13/22.
//
// Subclass of GFItemInfoVC that Displays a Card for a User's Repo Info

import UIKit

protocol RepoItemVCDelegate: AnyObject {
    func didTapGitHubProfile(for user: User)
}

class GFRepoItemVC: GFItemInfoVC {
    
    weak var delegate: RepoItemVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(color: .systemPurple, title: "Github Profile", systemImageName: "person.crop.circle")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGitHubProfile(for: user)
    }
}
