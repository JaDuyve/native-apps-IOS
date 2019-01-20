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

class RepoUserViewController: UIViewController, ResourceObserver {
    
    @IBOutlet weak var userAvatar: RemoteImageView!
    
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblJoined: UILabel!
    @IBOutlet weak var lblFullname: UILabel!
    @IBOutlet weak var lblBio: UILabel!
    @IBOutlet weak var lblCompanyIcon: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblEmailIcon: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblBlogIcon: UILabel!
    @IBOutlet weak var lblBlog: UILabel!
    
    @IBOutlet weak var lblFollowers: UILabel!
    @IBOutlet weak var lblFollowing: UILabel!
    @IBOutlet weak var lblRepositories: UILabel!
    
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
        lblEmail.text = user?.email
        lblBlog.text = user?.blog
        
        
        if let followers = user?.followers {
            lblFollowers.text = "\(followers)"
        }
        
        if let following = user?.following {
            lblFollowing.text = "\(following)"
        }
        
        if let repos = user?.publicRepos {
            lblRepositories.text = "\(repos)"
        }
        
        lblEmailIcon.setIcon(icon: .typIcons(.mail), iconSize: 25, color: Theme.UserIconLabels)
        lblBlog.setIcon(icon: .typIcons(.link), iconSize: 25, color: Theme.UserIconLabels)
        lblCompanyIcon.setIcon(icon: .dripicon(.userGroup), iconSize: 25, color: Theme.UserIconLabels)
    }
    
}
