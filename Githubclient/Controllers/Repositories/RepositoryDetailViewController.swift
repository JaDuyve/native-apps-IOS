//
//  RepositoryDetailViewController.swift
//  Githubclient
//
//  Created by Jari Duyvejonck on 29/12/2018.
//  Copyright © 2018 Jari Duyvejonck. All rights reserved.
//

import UIKit
import Siesta

class RepositoryDetailedViewController: UIViewController {
    @IBOutlet weak var avatarOwnerRepo: RemoteImageView!
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var repoOwner: UILabel!
    @IBOutlet weak var repoDescription: UILabel!
    @IBOutlet weak var contentTable: UITableView!
    
    var repository: Repository?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showRepository()
    }
    
    fileprivate func showRepository() {
        
        avatarOwnerRepo.imageURL = repository?.owner.avatarUrl
        
        repoName.text = repository?.name
        repoOwner.text = repository?.owner.login
        repoDescription.text = repository?.descriptionRepo
        
    }
    
}
