//
//  UserViewController.swift
//  Githubclient
//
//  Created by Jari Duyvejonck on 27/12/2018.
//  Copyright © 2018 Jari Duyvejonck. All rights reserved.
//

import UIKit
import Siesta

class UserViewController: UITableViewController, ResourceObserver {
    
    @IBOutlet weak var avatar: RemoteImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var selectedList: String = "repositories"
    
    var user: User? {
        didSet {
            self.populateUserView(user)
        }
    }
    
    var statusOverlay = ResourceStatusOverlay()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        statusOverlay.embed(in: self)
        populateUserView(nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userResource = APIService.user
    }
    
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        
        user = userResource?.typedContent()
    }
    
    var userResource: Resource? {
        didSet {
            
            oldValue?.removeObservers(ownedBy: self)
            oldValue?.cancelLoadIfUnobserved(afterDelay: 0.1)
            
            userResource?.addObserver(self)
                .addObserver(statusOverlay, owner: self)
                .loadIfNeeded()
        }
    }
    
    
    func populateUserView(_ user: User?) {
        usernameLabel.text = user?.login
        avatar.imageURL = user?.avatarUrl
        
        avatar.layer.borderWidth = 3.0;
        avatar.layer.borderColor = UIColor.white.cgColor
        avatar.layer.cornerRadius = 10.0
        avatar.layer.cornerRadius = avatar.frame.size.width / 2
        avatar.clipsToBounds = true;
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            selectedList = "Repositories"
            performSegue(withIdentifier: "show_repo_list", sender: self)
        case 2:
            selectedList = "Starred"
        case 3:
            selectedList = "Subscriptions"
            performSegue(withIdentifier: "show_repo_list", sender: self)
        default:
            return
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show_repo_list" {
            if let repoTable = segue.destination as? RepositoryTableController {
                switch selectedList {
                case "Repositories":
                    repoTable.repoListUrl = "repos"
                    repoTable.username = user?.login
                    repoTable.repoListNavigationItem.title = selectedList
                case "Subscriptions":
                    repoTable.repoListUrl = "subscriptions"
                    repoTable.username = user?.login
                    repoTable.repoListNavigationItem.title = selectedList
                default:
                    repoTable.repoListUrl = "repos"
                    repoTable.username = user?.login
                    repoTable.repoListNavigationItem.title = selectedList
                }
            }
        }
    }
}
