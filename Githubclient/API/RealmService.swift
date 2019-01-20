//
//  RealmService.swift
//  Githubclient
//
//  Created by Jari Duyvejonck on 19/01/2019.
//  Copyright © 2019 Jari Duyvejonck. All rights reserved.
//

import RealmSwift

let RealmService = _RealmService()

class _RealmService {
    
    let realm = try! Realm()
    
    func saveUser(user: User) {
        let realmUser = RealmUser(user)
        
        try! realm.write {
            realm.add(realmUser)
        }
    }
    
    func deleteUser(userId: Int) {
        guard let user = realm.objects(RealmUser.self).filter("id = \(userId)").first else {
            return
        }
        
        try! realm.write {
            realm.delete(user)
        }
        
    }
    
    func retrieveUser(userId: Int) -> User? {
        
        guard let user = realm.objects(RealmUser.self).filter("id = \(userId)").first else {
            return nil
        }
    
        return User(user)
    }
    
    func deletedbContent() {
        
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func saveRepositories(repositories: [Repository], group: String) {
        
        try! realm.write {
            repositories.forEach { repo in
                
                let realmRepository = RealmRepository(repo)
                realmRepository.group = group
                realm.add(realmRepository)
            }
        }
    }
    
    func deleteRepositories(group: String) {
        let realmRepositories = realm.objects(RealmRepository.self).filter("group = '\(group)'")
        
        try! realm.write {
            realm.delete(realmRepositories)
        }
    }
    
    func retrieveRepositories(group: String)  -> [Repository] {
        let realmRepositories = realm.objects(RealmRepository.self).filter("group = '\(group)'")
        var repositories: [Repository] = []
        
        var repo: Repository
        for i in 0...realmRepositories.count-1 {
            repo = Repository(realmRepositories[i])
            repositories.append(repo)
        }
        
        return repositories
    }
}
