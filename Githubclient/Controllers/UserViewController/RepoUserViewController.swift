//
//  RepoUser.swift
//  Githubclient
//
//  Created by Jari Duyvejonck on 20/01/2019.
//  Copyright © 2019 Jari Duyvejonck. All rights reserved.
//

import UIKit
import Siesta
import SwiftIcons
import SafariServices

class RepoUserViewController: UIViewController, ResourceObserver, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var userAvatar: RemoteImageView!
    
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblJoined: UILabel!
    @IBOutlet weak var lblFullname: UILabel!
    @IBOutlet weak var lblBio: UILabel!
    @IBOutlet weak var lblCompanyIcon: UILabel!
    @IBOutlet weak var lblEmailIcon: UILabel!
    @IBOutlet weak var lblBlogIcon: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnBlog: UIButton!
    
    
    @IBOutlet weak var lblFollowers: UILabel!
    @IBOutlet weak var lblFollowing: UILabel!
    @IBOutlet weak var lblRepositories: UILabel!
    @IBOutlet weak var svRepositories: UIStackView!
    
    
    
    var statusOverlay = ResourceStatusOverlay()
    
    var usernameForUrl: String?
    
    var user: User? {
        didSet {
            self.populateUserView(user)
        }
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let username = usernameForUrl else {
            performSegue(withIdentifier: "show_user_fromrepo", sender: nil)
            return
        }
        
        userResource = APIService.user(username)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusOverlay.embed(in: self)
        
        let UITapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tappedRepositories))
        UITapRecognizer.delegate = self
        svRepositories.addGestureRecognizer(UITapRecognizer)
        
        svRepositories.isUserInteractionEnabled = true
    }
    
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        user = userResource?.typedContent()
    }
    
    private func populateUserView(_ user: User?) {
        userAvatar.imageURL = user?.avatarUrl
        lblUsername.text = user?.login
        lblLocation.text = user?.location
        
        lblFullname.text = user?.name
        lblBio.text = user?.bio
        
        lblCompany.text = user?.company
        if user?.company != nil {
            lblCompany.text = user?.company
        } else {
            lblCompany.text = "No Company"
        }
        
        if user?.email != nil {
            btnEmail.setTitle(user?.email, for: .normal)
            btnEmail.isEnabled = true
        } else {
            btnEmail.setTitle("No Email", for: .normal)
            btnEmail.isEnabled = false
        }
        
        if user?.blog != "" {
            btnBlog.setTitle(user?.blog, for: .normal)
            btnBlog.isEnabled = true
        } else {
            btnBlog.setTitle("No Blog", for: .normal)
            btnBlog.isEnabled = false
        }
        
        if let followers = user?.followers {
            lblFollowers.text = "\(followers)"
        }
        
        if let following = user?.following {
            lblFollowing.text = "\(following)"
        }
        
        if let repos = user?.publicRepos {
            lblRepositories.text = "\(repos)"
        }
        
        lblEmailIcon.setIcon(icon: .typIcons(.mail), iconSize: 25, color: Theme.userIconLabels)
        lblBlogIcon.setIcon(icon: .typIcons(.link), iconSize: 25, color: Theme.userIconLabels)
        lblCompanyIcon.setIcon(icon: .dripicon(.userGroup), iconSize: 25, color: Theme.userIconLabels)
    }
    
    @objc func tappedRepositories() {
        performSegue(withIdentifier: "show_repositories_form_repo_user", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let repoTable = segue.destination as? RepositoryTableController {
            repoTable.repoListUrl = "not_cache_repositories"
            repoTable.username = user?.login
            repoTable.repoListNavigationItem.title = user?.login
        }
    }
    
    @IBAction func openBlog(_ sender: UIButton) {
        if let url = URL(string: user?.blog ?? "") {
            let svc = SFSafariViewController(url: url)
            present(svc, animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func openEmail(_ sender: UIButton) {
        guard let email = user?.email else {
            return
        }
        
        if let mailURL = URL(string: "mailto:\(email)") {
            if UIApplication.shared.canOpenURL(mailURL) {
                UIApplication.shared.open(mailURL, options: [:], completionHandler: nil)
            }
        }
    }
}

