//
//  UsersTableViewController.swift
//  Githubclient
//
//  Created by Jari Duyvejonck on 20/01/2019.
//  Copyright © 2019 Jari Duyvejonck. All rights reserved.
//

import Foundation
import UIKit
import Siesta

class UsersTableViewController: UITableViewController, ResourceObserver {
    
    @IBOutlet weak var nvItem: UINavigationItem!
    
    var users: [User] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var usersUrl: String?
    
    var usersResource: Resource? {
        didSet {
            oldValue?.removeObservers(ownedBy: self)
            
            usersResource?
                .addObserver(self)
                .addObserver(statusOverlay, owner: self)
                .loadIfNeeded()
        }
    }
    
    var statusOverlay = ResourceStatusOverlay()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusOverlay.embed(in: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let url = usersUrl else {
            return
        }
        
        usersResource = APIService.getFollowersOrFollowing(url: url)
    }
    
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        users = usersResource?.typedContent() ?? []
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "user_cell", for: indexPath)
        if let cell = cell as? UserTableCell {
            cell.user = users[(indexPath as IndexPath).row]
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show_user_from_follow" {
            if let userVC = segue.destination as? RepoUserViewController,
                let cell = sender as? UserTableCell {
                
                userVC.usernameForUrl = cell.user?.login
            }
        }
    }
    
}

class UserTableCell: UITableViewCell {
    
    
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var ivAvatar: RemoteImageView!
    
    
    
    var user: User? {
        didSet {
            lblUsername.text = user?.login
            ivAvatar.imageURL = user?.avatarUrl
        }
    }
}
