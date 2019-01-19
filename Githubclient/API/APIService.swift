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
        
        #if DEBUG
        // Bare-bones logging of which network calls Siesta makes:
        SiestaLog.Category.enabled = .detailed
        
        // For more info about how Siesta decides whether to make a network call,
        // and which state updates it broadcasts to the app:
        
        //SiestaLog.Category.enabled = .common
        
        // For the gory details of what Siesta’s up to:
        
        //SiestaLog.Category.enabled = .detailed
        
        // To dump all requests and responses:
        // (Warning: may cause Xcode console overheating)
        
        //SiestaLog.Category.enabled = .all
        #endif
        
        let jsonDecoder = JSONDecoder()
        
        
        service.configure {
            
            $0.pipeline[.cleanup].add(
                GitHubErrorMessageExtractor(jsonDecoder: jsonDecoder))
        }
        
        
        
        if let token = KeychainWrapper.standard.string(forKey: "githubclient_token")  {
            service.configure("**") {
                
                $0.headers["Authorization"] = token
            }
        }
        
        
        
        service.configureTransformer("/user") {
            // Decode json to User object
            
            try jsonDecoder.decode(User.self, from: $0.content)
        }
        
        service.configureTransformer("/users/*") {
            // Decode json to User object
            try jsonDecoder.decode(User.self, from: $0.content)
        }
        
        service.configureTransformer("/users/*/repos") {
            // Decode json to array of Repository Objcts
            try jsonDecoder.decode([Repository].self, from: $0.content)
        }
        
        service.configureTransformer("/users/*/subscriptions") {
            // Decode json to array of Repository Objects
            try jsonDecoder.decode([Repository].self, from: $0.content)
        }
        
        service.configureTransformer("/users/*/starred/repo") {
            // Decode json to array of Repository Objects
            try jsonDecoder.decode([Repository].self, from: $0.content)
        }
        
        service.configureTransformer("/repos/*/*/contents") {
            // Decode json to array of FileStructureItem Objects
            try jsonDecoder.decode([FileStructureItem].self, from: $0.content)
        }
        
        service.configureTransformer("/repos/*/*/readme") {
            try jsonDecoder.decode(FileStructureItem.self, from: $0.content)
        }
    }
    
    func clearToken() {
        service.configure("**") {
            $0.headers["Authorization"] = ""
        }
    }
    
    // -------------------- API CALLS ----------------------
    
    var user: Resource {
        return service
            .resource("/user")
    }
    
    func users(_ username: String) -> Resource {
        return service
            .resource("/users")
            .child(username.lowercased())
    }
    
    func repositories(owner username: String) -> Resource {
        return service
            .resource("/users/\(username)/repos")
    }
    
    func repositoriesSubscription(owner username: String) -> Resource {
        return service
            .resource("/users/\(username)/subscriptions")
    }
    
    func repositoriesStarred(owner username: String) -> Resource {
        return service
            .resource("/users/\(username)/starred/repos")
    }
    
//    func filesRepository(owner username: String, repositoryName: String) -> Resource {
//        return service
//        .resource("/repos/\(username)/\(repositoryName)/contents")
//    }
    
    func filesRepository(url: String) -> Resource {
        return service
            .resource(url)
    }
    
    func getReadmeRepository(owner username: String, repositoryName: String) -> Resource {
        return service
            .resource("/repos/\(username)/\(repositoryName)/readme")
    }
    
    func getContentReadmeRepository(readmeUrl url: String) -> Resource {
        return service
            .resource(url);
    }
    
    private struct GitHubErrorMessageExtractor: ResponseTransformer {
        let jsonDecoder: JSONDecoder
        
        func process(_ response: Response) -> Response {
            guard case .failure(var error) = response,     // Unless the response is a failure...
                let errorData: Data = error.typedContent(),  // ...with data...
                let githubError = try? jsonDecoder.decode(   // ...that encodes a standard GitHub error envelope...
                    GitHubErrorEnvelope.self, from: errorData)
                else {
                    return response                              // ...just leave it untouched.
            }
            
            error.userMessage = githubError.message        // GitHub provided an error message. Show it to the user!
            return .failure(error)
        }
        
        private struct GitHubErrorEnvelope: Decodable {
            let message: String
        }
    }
}
