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
}
