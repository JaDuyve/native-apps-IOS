//
//  User.swift
//  Githubclient
//
//  Created by Jari Duyvejonck on 27/12/2018.
//  Copyright © 2018 Jari Duyvejonck. All rights reserved.
//
import Foundation

struct User: Codable {
    let id: Int
    let login: String
    let name: String?
    let avatarUrl: String
    let followersUrl: String
    let followingUrl: String
    var followers: Int?
    var following: Int?
    var publicRepos: Int?
    let reposUrl: String
    let subscriptionsUrl: String
    var bio: String?
    var location: String?
    var email: String?
    var blog: String?
    var company: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case name
        case avatarUrl = "avatar_url"
        case followersUrl = "followers_url"
        case followingUrl = "following_url"
        case followers
        case following
        case publicRepos = "public_repos"
        case reposUrl = "repos_url"
        case subscriptionsUrl = "subscriptions_url"
        case bio
        case location
        case email
        case blog
        case company
    }
    
    init(_ user: RealmUser) {
        self.id = user.id
        self.login = user.login
        self.name = user.name
        self.avatarUrl = user.avatarUrl
        self.followersUrl = user.followersUrl
        self.followingUrl = user.followingUrl
        self.followers = user.followers
        self.following = user.following
        self.publicRepos = user.publicRepos
        self.reposUrl = user.reposUrl
        self.subscriptionsUrl = user.subscriptionUrl
        self.bio = user.bio
        self.location = user.location
        self.email = user.email
        self.blog = user.blog
        self.company = user.company
    }
}


