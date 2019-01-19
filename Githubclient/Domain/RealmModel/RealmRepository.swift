//
//  RealmRepository.swift
//  Githubclient
//
//  Created by Jari Duyvejonck on 19/01/2019.
//  Copyright © 2019 Jari Duyvejonck. All rights reserved.
//

import RealmSwift

class RealmRepository: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var fullName: String = ""
    @objc dynamic var privateRepo: Bool = true
    @objc dynamic var owner: RealmUser?
    @objc dynamic var descriptionRepo: String = ""
    @objc dynamic var language: String = ""
    @objc dynamic var stargazersCount: Int = 0
    @objc dynamic var forksCount: Int = 0
    @objc dynamic var watchersCount: Int = 0
    @objc dynamic var openIssues: Int = 0
    @objc dynamic var contentsUrl: String = ""
    @objc dynamic var commitsUrl: String = ""
    @objc dynamic var url: String = ""
    
    convenience init(
        id: Int,
        name: String,
        fullName: String,
        privateRepo: Bool,
        descriptionRepo: String,
        language: String,
        stargazersCount: Int,
        forksCount: Int,
        watchersCount: Int,
        openIssues: Int,
        contentsUrl: String,
        commitsUrl: String,
        url: String
        ) {
        self.init()
        self.id = id
        self.name = name
        self.fullName = fullName
        self.privateRepo = privateRepo
        self.descriptionRepo = descriptionRepo
        self.language = language
        self.stargazersCount = stargazersCount
        self.forksCount = forksCount
        self.watchersCount = watchersCount
        self.openIssues = openIssues
        self.contentsUrl = contentsUrl
        self.commitsUrl = commitsUrl
        self.url = url
    }
}
