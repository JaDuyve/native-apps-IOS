//
//  FileStructureRepoTableController.swift
//  Githubclient
//
//  Created by Jari Duyvejonck on 30/12/2018.
//  Copyright © 2018 Jari Duyvejonck. All rights reserved.
//

import Siesta
import UIKit

class FileStructureRepoTableController: UITableViewController, ResourceObserver {
    
    var title: String?
    var contentUrl: String?
    
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    var statusOverlay = ResourceStatusOverlay()
    
    var fileStructureContentsResource: Resource? {
        didSet {
            oldValue?.removeObservers(ownedBy: self)
            
            fileStructureContentsResource?
                .addObserver(self)
                .addObserver(statusOverlay, owner: self)
                .loadIfNeeded()
        }
    }
    
    var fileStructureContents: [FileStructureItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        if let owner = repository?.owner.login, let repoName = repository?.name {
//            fileStructureContentsResource = APIService.filesRepository(owner: owner, repositoryName: repoName)
//
//        }
        if let url = contentUrl {
            url.index(before: "/repos")
            fileStructureContentsResource = APIService.filesRepository(url: url)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileStructureContents.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        let fileStructureItem = fileStructureContents[(indexPath as IndexPath).row]
        
        switch fileStructureItem.type {
        case "file":
            cell = tableView.dequeueReusableCell(withIdentifier: "file_cell", for: indexPath)
            if let cell = cell as? fileTableCell {
                cell.fileItem = fileStructureItem
            }
        case "dir":
            cell = tableView.dequeueReusableCell(withIdentifier: "dir_cell", for: indexPath)
            if let cell = cell as? fileTableCell {
                cell.fileItem = fileStructureItem
            }
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "file_cell", for: indexPath)
            if let cell = cell as? fileTableCell {
                cell.fileItem = fileStructureItem
            }
        }
        
        
        return cell!
    }
    
    
    
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        fileStructureContents = fileStructureContentsResource?.typedContent() ?? []
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "show_filestructure_new_dir":
            if let files = segue.destination as? FileStructureRepoTableController,
                let cell = sender as? fileTableCell {
                files.contentUrl = cell.fileItem?.url
            }
        case "show_file_webview":
            if let webView = segue.destination as? fileWebViewController,
                let cell = sender as? fileTableCell {
                
                webView.file = cell.fileItem
            }
        default:
            return
        }
        
    }
}






class fileTableCell: UITableViewCell {
    
    var fileItem: FileStructureItem? {
        didSet {
            self.textLabel?.text = fileItem?.name
        }
    }
    
}


