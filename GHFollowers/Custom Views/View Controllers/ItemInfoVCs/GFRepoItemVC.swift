//
//  GFRepoItemVC.swift
//  GHFollowers
//
//  Created by Christian Diaz on 7/13/22.
//
// Subclass of GFItemInfoVC that Displays a Card for a User's Repo Info

import UIKit

class GFRepoItemVC: GFItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "Github Profile")
    }
}
