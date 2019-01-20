//
//  ViewController.swift
//  Githubclient
//
//  Created by Jari Duyvejonck on 26/12/2018.
//  Copyright © 2018 Jari Duyvejonck. All rights reserved.
//

import UIKit
import p2_OAuth2
import SwiftKeychainWrapper
import RealmSwift

class LoginViewController: UIViewController {
    
    var loader: OAuth2DataLoader?
    
    var oauth2 = OAuth2CodeGrant(settings: [
        "client_id": "454dcf07599e4f6f9c1e",
        "client_secret": "5e9d6d7c5604286123e405a2738d229a3d780cae",
        "authorize_uri": "https://github.com/login/oauth/authorize",
        "token_uri": "https://github.com/login/oauth/access_token",
        "scope": "user repo:status",
        "redirect_uris": ["githubclient://callback"],
        "secret_in_body": true,
        "verbose": true,
        
        ] as OAuth2JSON)
    
    var isLogedOut = false
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        
        if KeychainWrapper.standard.string(forKey: "githubclient_token") != nil  {
            performSegue(withIdentifier: "show_user_profile", sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isLogedOut {
            logout()
            reInitializeOauth2()
        }
    }
    
    
    private func logout() {
        oauth2.forgetTokens()
        let storage = HTTPCookieStorage.shared
        storage.cookies?.forEach() {storage.deleteCookie($0)}
        RealmService.deletedbContent()
        KeychainWrapper.standard.removeAllKeys()
        isLogedOut = false
        
    }
    
    private func reInitializeOauth2() {
        oauth2 = OAuth2CodeGrant(settings: [
            "client_id": "454dcf07599e4f6f9c1e",
            "client_secret": "5e9d6d7c5604286123e405a2738d229a3d780cae",
            "authorize_uri": "https://github.com/login/oauth/authorize",
            "token_uri": "https://github.com/login/oauth/access_token",
            "scope": "user repo:status",
            "redirect_uris": ["githubclient://callback"],
            "secret_in_body": true,
            "verbose": true,
            
            ] as OAuth2JSON)
    }
    
    @IBAction func login(_ sender: UIButton) {
        if oauth2.isAuthorizing {
            oauth2.abortAuthorization()
            return
        }
        
        
        oauth2.authConfig.authorizeEmbedded = true              // uses a inapp browser
        oauth2.authConfig.authorizeContext = self
        
        oauth2.authorize() {
            authParameters, error in
            
            if authParameters != nil {
                self.saveToken(token: self.oauth2.accessToken)
            }
            else {
                
            }
        }
        
    }
    
    private func saveToken(token: String?) {
        guard let newToken = token else {
            return
        }
        
        let saveSuccessful: Bool = KeychainWrapper.standard.set("Bearer \(newToken)", forKey: "githubclient_token")
        let storage = HTTPCookieStorage.shared
        
        if !saveSuccessful {
            oauth2.forgetTokens()
            
            storage.cookies?.forEach() {
                storage.deleteCookie($0)
            }
        }
        
        
        performSegue(withIdentifier: "show_user_profile", sender: nil)
        
        
    }
    
}

