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
    var owner: User?
    let descriptionRepo: String?
    let language: String?
    let stargazersCount: Int?
    let forksCount: Int
    let watchersCount: Int
    let openIssues: Int
    let contentsUrl: String
    let commitsUrl: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case privateRepo = "private"
        case owner
        case descriptionRepo = "description"
        case language
        case stargazersCount = "stargazers_count"
        case forksCount = "forks_count"
        case watchersCount = "watchers_count"
        case openIssues = "open_issues"
        case contentsUrl = "contents_url"
        case commitsUrl = "commits_url"
        case url
    }
    
    init(_ repository: RealmRepository) {
        self.id = repository.id
        self.fullName = repository.fullName
        self.name = repository.name
        if let owner = repository.owner {
            self.owner = User(owner)
        }
        
        self.privateRepo = repository.privateRepo
        self.descriptionRepo = repository.descriptionRepo
        self.language = repository.language
        self.stargazersCount = repository.stargazersCount
        self.forksCount = repository.forksCount
        self.watchersCount = repository.watchersCount
        self.openIssues = repository.openIssues
        self.contentsUrl = repository.contentsUrl
        self.commitsUrl = repository.commitsUrl
        self.url = repository.url
    }
}

