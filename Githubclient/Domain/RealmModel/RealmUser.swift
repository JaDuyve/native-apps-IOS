//
//  RealmUser.swift
//  Githubclient
//
//  Created by Jari Duyvejonck on 30/12/2018.
//  Copyright © 2018 Jari Duyvejonck. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

class RealmUser: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var login: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var avatarUrl: String = ""
    @objc dynamic var followersUrl: String = ""
    @objc dynamic var followingUrl: String = ""
    @objc dynamic var followers: Int = 0
    @objc dynamic var following: Int = 0
    @objc dynamic var publicRepos: Int = 0
    @objc dynamic var reposUrl: String = ""
    @objc dynamic var subscriptionUrl: String = ""
    @objc dynamic var bio: String = ""
    @objc dynamic var location: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var blog: String = ""
    
    convenience init(
        id: Int,
        login: String,
        name: String,
        avatarUrl: String,
        followersUrl: String,
        followingUrl: String,
        followers: Int,
        following: Int,
        publicRepos: Int,
        reposUrl: String,
        subscriptionUrl: String,
        bio: String,
        location: String,
        email: String,
        blog: String
        ) {
        self.init()
        self.id = id
        self.login = login
        self.name = name
        self.avatarUrl = avatarUrl
        self.followersUrl = followersUrl
        self.followingUrl = followingUrl
        self.followers = followers
        self.following = following
        self.publicRepos = publicRepos
        self.reposUrl = reposUrl
        self.subscriptionUrl = subscriptionUrl
        self.bio = bio
        self.location = location
        self.email = email
        self.blog = blog
        
    }
    
    convenience init(_ user: User) {
        self.init()
        self.id = user.id
        self.login = user.login
        self.name = user.name ?? ""
        self.avatarUrl = user.avatarUrl
        self.followersUrl = user.followersUrl
        self.followingUrl = user.followingUrl
        self.followers = user.followers  ?? 0
        self.following = user.following  ?? 0
        self.publicRepos = user.publicRepos ?? 0
        self.reposUrl = user.reposUrl
        self.subscriptionUrl = user.subscriptionsUrl
        self.bio = user.bio ?? ""
        self.location = user.location ?? ""
        self.email = user.email ?? ""
        self.blog = user.blog ?? ""
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
