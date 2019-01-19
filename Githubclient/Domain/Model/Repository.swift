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
}

