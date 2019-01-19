//
//  RepositoryDetailViewController.swift
//  Githubclient
//
//  Created by Jari Duyvejonck on 29/12/2018.
//  Copyright © 2018 Jari Duyvejonck. All rights reserved.
//

import UIKit
import Siesta
import MarkdownView
import SwiftIcons

class RepositoryDetailedViewController: UIViewController, ResourceObserver {
    
    @IBOutlet weak var avatar: RemoteImageView!
    @IBOutlet weak var mdView: MarkdownView!
    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var owner: UILabel!
    @IBOutlet weak var repoDescription: UILabel!
    @IBOutlet weak var btnStar: UIButton!
    
    @IBOutlet weak var lblStars: UILabel!
    @IBOutlet weak var lblIssues: UILabel!
    @IBOutlet weak var lblForks: UILabel!
    @IBOutlet weak var lblWatchers: UILabel!
    
    var repository: Repository?
    
    
    
    var readme: FileStructureItem? {
        return readmeResource?.typedContent()
    }
    
    var isStarred: Bool {
        return starResource?.typedContent() ?? false
    }
    
    var readmeResource: Resource? {
        didSet {
            oldValue?.removeObservers(ownedBy: self)
            oldValue?.cancelLoadIfUnobserved(afterDelay: 0.1)
            
            readmeResource?.addObserver(self)
                .loadIfNeeded()
        }
    }
    
    var starResource: Resource? {
        didSet {
            oldValue?.removeObservers(ownedBy: self)
            oldValue?.cancelLoadIfUnobserved(afterDelay: 0.1)
            
            starResource?.addObserver(self)
                .loadIfNeeded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showRepository()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let owner = repository?.owner.login,  let repoName = repository?.name  {
            readmeResource = APIService.getReadmeRepository(owner: owner, repositoryName: repoName)
        }
        
        if let repo = repository {
            starResource = APIService.currentRepoStarred(repo)
        }
    }
    
    
    
    private func showRepository() {
        
        avatar.imageURL = repository?.owner.avatarUrl
        projectName.text = repository?.name
        owner.text = repository?.owner.login
        repoDescription.text = repository?.descriptionRepo
        
        if let stars = repository?.stargazersCount {
            lblStars.text = "\(stars)"
        }
        
        if let forks = repository?.forksCount {
            lblForks.text = "\(forks)"
        }
        
        if let issues = repository?.openIssues {
            lblIssues.text = "\(issues)"
        }
        
        if let watchers = repository?.watchersCount {
            lblWatchers.text = "\(watchers)"
        }
        
        showStarred()
        
    }
    
    private func showStarred() {
        
        if isStarred {
            btnStar.setIcon(icon: .typIcons(.star), iconSize: 25, color: .yellow, forState: .normal)
        } else {
            btnStar.setIcon(icon: .typIcons(.starOutline),iconSize: 25 ,color: .yellow, forState: .normal)
        }
    }
    
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        setReadme()
        showStarred()
    }
    
    
    
    private func setReadme() {
        
        if let url = readme?.downloadUrl {
            
            let session = URLSession(configuration: .default)
            let url = URL(string: url)!
            let task = session.dataTask(with: url) { [weak self] data, _, _ in
                let str = String(data: data!, encoding: String.Encoding.utf8)
                DispatchQueue.main.async {
                    self?.mdView.load(markdown: str)
                }
            }
            task.resume()
        }
    }
    
    @IBAction func clickStar(_ sender: UIButton) {
        guard let repo = repository else {
            return
        }
        
        btnStar?.isEnabled = false
        APIService.starRepository(isStarred: !isStarred, repository: repo)
            .onCompletion {
            _ in self.btnStar?.isEnabled = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show_file_structure_repo" {
            if let files = segue.destination as? FileStructureRepoTableController {
                
                files.contentUrl = repository?.contentsUrl
                files.title = "Files"
            }
        }
    }
    
    
}
