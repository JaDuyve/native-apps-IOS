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

class LoginViewController: UIViewController {
    
    var loader: OAuth2DataLoader?
    
    var oauth2 = OAuth2CodeGrant(settings: [
        "client_id": "454dcf07599e4f6f9c1e",                         // yes, this client-id and secret will work!
        "client_secret": "5e9d6d7c5604286123e405a2738d229a3d780cae",
        "authorize_uri": "https://github.com/login/oauth/authorize",
        "token_uri": "https://github.com/login/oauth/access_token",
        "scope": "user repo:status",                                 // make it possible to write to github api
        "redirect_uris": ["githubclient://callback"],            // app has registered this scheme
        "secret_in_body": true,                                      // GitHub does not accept client secret in the Authorization header
        "verbose": true,
        
        ] as OAuth2JSON)
    
    override func viewDidAppear(_ animated: Bool) {
    
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        
        if KeychainWrapper.standard.string(forKey: "githubclient_token") != nil  {
            performSegue(withIdentifier: "show_user_profile", sender: nil)
        }
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

