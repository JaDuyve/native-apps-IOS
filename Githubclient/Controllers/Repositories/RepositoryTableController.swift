//
//  RepositoryTableController.swift
//  Githubclient
//
//  Created by Jari Duyvejonck on 28/12/2018.
//  Copyright © 2018 Jari Duyvejonck. All rights reserved.
//

import UIKit
import Siesta

class RepositoryTableController: UITableViewController, ResourceObserver {
    
    @IBOutlet weak var repoListNavigationItem: UINavigationItem!
    
    var repoListUrl: String?
    var username: String?
    
    var repositories: [Repository] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var repositoriesResource: Resource? {
        didSet {
            oldValue?.removeObservers(ownedBy: self)
            
            repositoriesResource?
                .addObserver(self)
                .addObserver(statusOverlay, owner: self)
                .loadIfNeeded()
        }
    }
    
    var statusOverlay = ResourceStatusOverlay()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        statusOverlay.embed(in: self)
        
        guard let username_checked = username else {
            performSegue(withIdentifier: "show_user_fromrepo", sender: nil)
            return
        }
        
        guard let url_checked = repoListUrl else {
            performSegue(withIdentifier: "show_user_fromrepo", sender: nil)
            
            return
        }
        
        switch url_checked {
        case "repos":
            repositoriesResource = APIService.repositories(owner: username_checked)
        case "subscriptions":
            repositoriesResource = APIService.repositoriesSubscription(owner: username_checked)
        default:
            performSegue(withIdentifier: "show_user_fromrepo", sender: nil)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repository", for: indexPath)
        if let cell = cell as? RepositoryTableCell {
            cell.repository = repositories[(indexPath as IndexPath).row]
        }
        return cell
    }
    
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        repositories = repositoriesResource?.typedContent() ?? []
        
    }
}


class RepositoryTableCell: UITableViewCell {
    
    @IBOutlet weak var repoOwnerAvatar: RemoteImageView!
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var repoDescription: UILabel!
    
    
    var repository: Repository? {
        didSet {
            print(repository)
            
            
            repoName.text = repository?.name
            language.text = repository?.language
            repoDescription.text = repository?.descriptionRepo
            
            if let avatarUrl = repository?.owner.avatarUrl {
                repoOwnerAvatar.imageURL = avatarUrl
            }
        }
    }
}
