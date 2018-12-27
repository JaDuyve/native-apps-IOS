//
//  APIService.swift
//  Githubclient
//
//  Created by Jari Duyvejonck on 27/12/2018.
//  Copyright © 2018 Jari Duyvejonck. All rights reserved.
//

import Siesta
import SwiftKeychainWrapper

let APIService = _APIService()

class _APIService {
    
    private let service = Service(
        baseURL: "https://api.github.com",
        standardTransformers: [.text, .image]
    )
    
    fileprivate init() {
        
        
        let jsonDecoder = JSONDecoder()
        
        if let token = KeychainWrapper.standard.string(forKey: "githubclient_token")  {
            service.configure("**") {
                
                $0.headers["Authorization"] = token
            }
        }
        
        service.configureTransformer("/users/*") {
            // Decode json to User object
            try jsonDecoder.decode(User.self, from: $0.content)
        }
        
        service.configureTransformer("/users/*/repos") {
            // Decode json to array of Repository Objcts
            try jsonDecoder.decode([Repository].self, from: $0.content)
        }
    }
    
    func clearToken() {
        service.configure("**") {
            $0.headers["Authorization"] = ""
        }
    }
    
    // -------------------- API CALLS ----------------------
    
    func user(_ username: String) -> Resource {
        return service
            .resource("/users")
            .child(username.lowercased())
    }
    
    func repository(owner username: String, repositoryName name: String) -> Resource {
        return service
            .resource("/repos")
            .child(username)
            .child(name)
    }
}
