////
////  User.swift
////  Githubclient
////
////  Created by Jari Duyvejonck on 27/12/2018.
////  Copyright © 2018 Jari Duyvejonck. All rights reserved.
////
//




//
//class User: Object, Decodable {
//    @objc dynamic var id: Int = 0
//    @objc dynamic var login: String = ""
//    @objc dynamic var avatarUrl: String = ""
//    @objc dynamic var followersUrl: String = ""
//    @objc dynamic var followingUrl: String = ""
//    @objc dynamic var followers: Int = 0
//    @objc dynamic var following: Int = 0
//    @objc dynamic var publicRepos: Int = 0
//    @objc dynamic var reposUrl: String = ""
//    @objc dynamic var subscriptionUrl: String = ""
//
//    convenience init(
//        id: Int,
//        login: String,
//        avatarUrl: String,
//        followersUrl: String,
//        followingUrl: String,
//        followers: Int,
//        following: Int,
//        publicRepos: Int,
//        reposUrl: String,
//        subscriptionUrl: String
//        ) {
//        self.init()
//        self.id = id
//        self.login = login
//        self.avatarUrl = avatarUrl
//        self.followersUrl = followersUrl
//        self.followingUrl = followingUrl
//        self.followers = followers
//        self.following = following
//        self.publicRepos = publicRepos
//        self.reposUrl = reposUrl
//        self.subscriptionUrl = subscriptionUrl
//    }
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case login
//        case avatarUrl    = "avatar_url"
//        case followersUrl = "followers_url"
//        case followingUrl = "following_url"
//        case followers
//        case following
//        case publicRepos  = "public_repos"
//        case reposUrl     = "repos_url"
//        case subscriptionUrl = "subscription_url"
//    }
//
//    convenience required init(from decoder:Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let userId = try container.decode(Int.self, forKey: .id)
//        let login = try container.decode(String.self, forKey: .login)
//        let avatarUrl = try container.decode(String.self, forKey: .avatarUrl)
//        let followingUrl = try container.decode(String.self, forKey: .followingUrl)
//        let followersUrl = try container.decode(String.self, forKey: .followersUrl)
//        let followers = try container.decode(Int.self, forKey: .followers)
//        let following = try container.decode(Int.self, forKey: .following)
//        let publicRepos = try container.decode(Int.self, forKey: .publicRepos)
//        let reposUrl = try container.decode(String.self, forKey: .reposUrl)
//        let subscriptionUrl = try container.decode(String.self, forKey: .subscriptionUrl)
//        self.init(
//            id: userId,
//            login: login,
//            avatarUrl: avatarUrl,
//            followersUrl: followingUrl,
//            followingUrl: followersUrl,
//            followers: followers,
//            following: following,
//            publicRepos:publicRepos,
//            reposUrl:reposUrl,
//            subscriptionUrl:subscriptionUrl)
//    }
//
//    required init() {
//        super.init()
//    }
//
//    required init(value: Any, schema: RLMSchema) {
//        super.init(value: value, schema: schema)
//    }
//
//    required init(realm: RLMRealm, schema: RLMObjectSchema) {
//        super.init(realm: realm, schema: schema)
//    }
//
//}
//
//
