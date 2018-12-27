//
//  Repository.swift
//  Githubclient
//
//  Created by Jari Duyvejonck on 27/12/2018.
//  Copyright © 2018 Jari Duyvejonck. All rights reserved.
//

struct Repository: Codable {
    let id: Int
    let name: String
    let fullName: String
    let privateRepo: Bool
    let owner: User
    let descriptionRepo: String?
    let language: String
    let stargazersCount: Int?
    let forksCount: Int
    let contentUrl: String
    let commitsUrl: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case privateRepo = "private_repo"
        case owner
        case descriptionRepo = "description"
        case language
        case stargazersCount = "stargazers_count"
        case forksCount = "forks_count"
        case contentUrl = "content_url"
        case commitsUrl = "commits_url"
        case url
    }
}

//import UIKit
//import Realm
//import RealmSwift
//
//class Repository: Object, Decodable {
//    @objc dynamic var id: Int = 0
//    @objc dynamic var name: String = ""
//    @objc dynamic var fullName: String = ""
//    @objc dynamic var privateRepo: Bool = false
//    @objc dynamic var owner: User = User()
//    @objc dynamic var descriptionRepo: String = ""
//    @objc dynamic var language: String = ""
//    @objc dynamic var stargazersCount: Int = 0
//    @objc dynamic var forksCount: Int = 0
//    @objc dynamic var contentUrl: String = ""
//    @objc dynamic var commitsUrl: String = ""
//    @objc dynamic var url: String = ""
//
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case name
//        case fullName = "full_name"
//        case privateRepo = "private"
//        case owner
//        case descriptionRepo = "description"
//        case language
//        case stargazersCount = "stargazers_count"
//        case forksCount = "forks_count"
//        case contentUrl = "content_url"
//        case commitsUrl = "commit_url"
//        case url
//    }
//
//    convenience init(
//        id: Int,
//        name: String,
//        fullName: String,
//        privateRepo: Bool,
//        owner: User,
//        descriptionRepo: String,
//        language: String,
//        stargazersCount: Int,
//        forksCount: Int,
//        contentUrl: String,
//        commitsUrl: String,
//        url: String
//        ) {
//        self.init()
//        self.id = id
//        self.name = name
//        self.fullName = fullName
//        self.privateRepo = privateRepo
//        self.owner = owner
//        self.descriptionRepo = descriptionRepo
//        self.language = language
//        self.stargazersCount = stargazersCount
//        self.forksCount = forksCount
//        self.contentUrl = contentUrl
//        self.commitsUrl = commitsUrl
//        self.url = url
//    }
//
//    convenience required init(from decoder:Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let repoId = try container.decode(Int.self, forKey: .id)
//        let name = try container.decode(String.self, forKey: .name)
//        let fullName = try container.decode(String.self, forKey: .fullName)
//        let privateRepo = try container.decode(Bool.self, forKey: .privateRepo)
//        let owner = try container.decode(User.self, forKey: .owner)
//        let descriptionRepo = try container.decode(String.self, forKey: .descriptionRepo)
//        let language = try container.decode(String.self, forKey: .language)
//        let stargazersCount = try container.decode(Int.self, forKey: .stargazersCount)
//        let forksCount = try container.decode(Int.self, forKey: .forksCount)
//        let contentUrl = try container.decode(String.self, forKey: .contentUrl)
//        let commitsUrl = try container.decode(String.self, forKey: .commitsUrl)
//        let url = try container.decode(String.self, forKey: .url)
//        self.init(
//            id: repoId,
//            name: name,
//            fullName: fullName,
//            privateRepo: privateRepo,
//            owner: owner,
//            descriptionRepo: descriptionRepo,
//            language: language,
//            stargazersCount:stargazersCount,
//            forksCount:forksCount,
//            contentUrl:contentUrl,
//            commitsUrl: commitsUrl,
//            url: url)
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
//}
