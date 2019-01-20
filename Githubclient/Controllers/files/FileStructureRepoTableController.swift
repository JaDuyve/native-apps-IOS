//
//  FileStructureRepoTableController.swift
//  Githubclient
//
//  Created by Jari Duyvejonck on 30/12/2018.
//  Copyright © 2018 Jari Duyvejonck. All rights reserved.
//

import Siesta
import UIKit
import SwiftIcons

class FileStructureRepoTableController: UITableViewController, ResourceObserver {
    
    var nvTitle: String?
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationTitle.title = nvTitle ?? "Files"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let url = contentUrl else {
            return
        }
        
        let cleanUrl = self.cleanUrl(url: url)
        let urlWithoutBaseUrl = self.removeBaseurl(url: cleanUrl)
        print(urlWithoutBaseUrl)
        fileStructureContentsResource = APIService.filesRepository(url: urlWithoutBaseUrl)
        
    }
    
    private func cleanUrl(url: String) -> String {
        let newUrl = self.removeTextAfter(text: url, indexText: "{")
        return self.removeTextAfter(text: newUrl, indexText: "?")
    }
    
    private func removeTextAfter(text: String, indexText: String) -> String {
        let range = text.range(of: indexText)
        
        guard let newRange = range else {
            return text
        }
        
        let start = newRange.lowerBound
        
        return String(text[text.startIndex..<start])
    }
    
    private func removeBaseurl(url: String) -> String {
        let range = url.range(of: "/repos")
        guard let newRange = range else {
            
            return url
        }
        
        let start = newRange.lowerBound
        
        return String(url[start..<url.endIndex])
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
        let temp: [FileStructureItem] = fileStructureContentsResource?.typedContent() ?? []
        fileStructureContents = temp.sorted(by: {(first: FileStructureItem, second: FileStructureItem) -> Bool in
            first.type < second.type
        })
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
            
            if fileItem?.type == "dir" {
                self.imageView?.setIcon(icon: .typIcons(.folder))

            } else if fileItem?.type == "file" {
                self.imageView?.setIcon(icon: .typIcons(.document))
            }
        }
    }
    
    
    
}
