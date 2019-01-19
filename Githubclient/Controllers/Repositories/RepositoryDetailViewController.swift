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


class RepositoryDetailedViewController: UIViewController, ResourceObserver {
    
    @IBOutlet weak var avatar: RemoteImageView!
    @IBOutlet weak var mdView: MarkdownView!
    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var owner: UILabel!
    @IBOutlet weak var repoDescription: UILabel!
    
    @IBOutlet weak var lblStars: UILabel!
    @IBOutlet weak var lblIssues: UILabel!
    @IBOutlet weak var lblForks: UILabel!
    @IBOutlet weak var lblWatchers: UILabel!
    
    var repository: Repository?
    
    var readme: FileStructureItem? {
        didSet {
            setReadme()
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
    }
    
   
    
    fileprivate func showRepository() {
        
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
        
        
    }
    
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        readme = readmeResource?.typedContent()
    }
    
    var readmeResource: Resource? {
        didSet {
            oldValue?.removeObservers(ownedBy: self)
            oldValue?.cancelLoadIfUnobserved(afterDelay: 0.1)
            
            readmeResource?.addObserver(self)
                .loadIfNeeded()
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show_file_structure_repo" {
            if let files = segue.destination as? FileStructureRepoTableController {
                
                files.repository = repository
            }
        }
    }
    
    
}
