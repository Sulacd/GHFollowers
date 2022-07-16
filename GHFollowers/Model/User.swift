//
//  User.swift
//  GHFollowers
//
//  Created by Christian Diaz on 6/30/22.
//

import Foundation

struct User: Codable {
    let login: String
    let avatarUrl: String
    let htmlUrl: String
    var name: String?
    var location: String?
    var bio: String?
    let publicRepos: Int
    let publicGists: Int
    let following: Int
    let followers: Int
    let createdAt: String
}
