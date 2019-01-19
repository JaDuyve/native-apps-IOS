//
//  FileStructureItem.swift
//  Githubclient
//
//  Created by Jari Duyvejonck on 30/12/2018.
//  Copyright © 2018 Jari Duyvejonck. All rights reserved.
//


struct FileStructureItem: Codable {
    let name: String
    let path: String
    let downloadUrl: String?
    let type: String
    let url: String
    
    
    enum CodingKeys: String, CodingKey {
        case name
        case path
        case downloadUrl = "download_url"
        case type
        case url
        
    }
}
