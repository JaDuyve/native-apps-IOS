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
        guard let user = realm.object(ofType: RealmUser.self, forPrimaryKey: userId) else {
            return
        }
        
        try! realm.write {
            realm.delete(user)
        }
        
    }
    
    func retrieveUser(userId: Int) -> User? {
        
        guard let user = realm.object(ofType: RealmUser.self, forPrimaryKey: userId) else {
            return nil
        }
    
        return User(user)
    }
    
    func deletedbContent() {
        
        try! realm.write {
            realm.deleteAll()
        }
    }
}
