//
//  FileWebView.swift
//  Githubclient
//
//  Created by Jari Duyvejonck on 18/01/2019.
//  Copyright © 2019 Jari Duyvejonck. All rights reserved.
//

import UIKit

class fileWebViewController: UIViewController {
    
    
    @IBOutlet weak var webView: UIWebView!
    
    var file: FileStructureItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showFile()
    }
    
    private func showFile() {
        
        if let downloadUrl = file?.downloadUrl {
            print(downloadUrl)
            let url = NSURL(string: downloadUrl)
            let request = NSURLRequest(url: url! as URL)
            
            webView.loadRequest(request as URLRequest)
        }
    }
}
