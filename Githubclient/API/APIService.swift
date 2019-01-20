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
        
        let formatter = DateFormatter()
        let jsonDecoder = JSONDecoder()
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        service.configure {
            
            $0.pipeline[.cleanup].add(
                GitHubErrorMessageExtractor(jsonDecoder: jsonDecoder))
        }
        
        
        
        if let token = KeychainWrapper.standard.string(forKey: "githubclient_token")  {
            service.configure("**") {
                
                $0.headers["Authorization"] = token
            }
        }
        
        service.configure("/user/starred/*/*") {
            $0.pipeline[.model].add(TrueIfRepositoryStarred())
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
        
        service.configureTransformer("/users/*/starred") {
            // Decode json to array of Repository Objects
            try jsonDecoder.decode([Repository].self, from: $0.content)
        }
        
        service.configureTransformer("/repos/*/*/contents/**") {
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
    
    func user(_ username: String) -> Resource {
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
            .resource("/users/\(username)/starred")
    }
    
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
    
    func currentRepoStarred(_ repository: Repository) -> Resource {
        return service
            .resource("/user/starred/")
            .child(repository.owner?.login ?? "")
            .child(repository.name)
        
    }
    
    func starRepository(isStarred: Bool, repository: Repository) -> Request {
        let starResource = currentRepoStarred(repository)
        return starResource
            .request(isStarred ? .put : .delete)
            .onSuccess{ _ in
                starResource.overrideLocalContent(with: isStarred)
        }
    }
    
    private struct GitHubErrorMessageExtractor: ResponseTransformer {
        let jsonDecoder: JSONDecoder
        
        func process(_ response: Response) -> Response {
            guard case .failure(var error) = response,
                let errorData: Data = error.typedContent(),
                let githubError = try? jsonDecoder.decode(
                    GitHubErrorEnvelope.self, from: errorData)
                else {
                    return response
            }
            
            error.userMessage = githubError.message        
            return .failure(error)
        }
        
        private struct GitHubErrorEnvelope: Decodable {
            let message: String
        }
    }
    
    private struct TrueIfRepositoryStarred: ResponseTransformer {
        func process(_ result: Response) -> Response {
            switch result {
            case .success(var entity):
                entity.content = true
                return logTransformation(
                    .success(entity))
                
            case .failure(let error):
                if error.httpStatusCode == 404, var entity = error.entity {
                    entity.content = false
                    return logTransformation(
                        .success(entity))
                } else {
                    return result
                }
            }
        }
    }
}
