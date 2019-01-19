//
//  RealmUser.swift
//  Githubclient
//
//  Created by Jari Duyvejonck on 30/12/2018.
//  Copyright © 2018 Jari Duyvejonck. All rights reserved.
//

import UIKit
import RealmSwift

class RealmUser: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var login: String = ""
    @objc dynamic var avatarUrl: String = ""
    @objc dynamic var followersUrl: String = ""
    @objc dynamic var followingUrl: String = ""
    @objc dynamic var followers: Int = 0
    @objc dynamic var following: Int = 0
    @objc dynamic var publicRepos: Int = 0
    @objc dynamic var reposUrl: String = ""
    @objc dynamic var subscriptionUrl: String = ""
    
    
    convenience init(
        id: Int,
        login: String,
        avatarUrl: String,
        followersUrl: String,
        followingUrl: String,
        followers: Int,
        following: Int,
        publicRepos: Int,
        reposUrl: String,
        subscriptionUrl: String
        ) {
        self.init()
        self.id = id
        self.login = login
        self.avatarUrl = avatarUrl
        self.followersUrl = followersUrl
        self.followingUrl = followingUrl
        self.followers = followers
        self.following = following
        self.publicRepos = publicRepos
        self.reposUrl = reposUrl
        self.subscriptionUrl = subscriptionUrl
    }
    
    convenience init(_ user: User) {
        self.init()
        self.id = user.id
        self.login = user.login
        self.avatarUrl = user.avatarUrl
        self.followersUrl = user.followersUrl
        self.followingUrl = user.followingUrl
        self.followers = user.followers  ?? 0
        self.following = user.following  ?? 0
        self.publicRepos = user.publicRepos ?? 0
        self.reposUrl = user.reposUrl
        self.subscriptionUrl = user.subscriptionsUrl
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
