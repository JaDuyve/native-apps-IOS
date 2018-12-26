//
//  ViewController.swift
//  GithubClient-native-apps-IOS
//
//  Created by Jari Duyvejonck on 26/12/2018.
//  Copyright © 2018 Jari Duyvejonck. All rights reserved.
//

import UIKit
import OAuthSwift

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    private func presentAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func login(_ sender: UIButton) {
        let oauthswift = OAuth2Swift(
            consumerKey:    "454dcf07599e4f6f9c1e",
            consumerSecret: "5e9d6d7c5604286123e405a2738d229a3d780cae",
            authorizeUrl:   "https://github.com/login/oauth/authorize",
            accessTokenUrl: "https://github.com/login/oauth/access_token",
            responseType:   "code"
        )
        
        oauthswift.allowMissingStateCheck = true
        oauthswift.authorizeURLHandler = SafariURLHandler(viewController: self, oauthSwift: oauthswift)
        
        guard let rwURL = URL(string: "githubclient://callback") else {
            return
        }
        
        oauthswift.authorize(
            withCallbackURL: rwURL,
            scope: "",
            state: "",
            success: { (credential, response, parameters) in
                
            print(credential.oauthToken)
        },
            failure:  {error in
                self.presentAlert("Error", message: error.localizedDescription)
        }
        )
        
    }
    
    private func retrieveTokenSuccess(credential: OAuthSwiftCredential, response: OAuthSwiftResponse, parameters: OAuthSwift.Parameters) {
        
    }
    
}

