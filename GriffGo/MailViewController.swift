//
//  SecondViewController.swift
//  real back up
//
//  Created by Corbin Stephen Schneider on 12/11/16.
//  Copyright © 2016 Corbin Stephen Schneider. All rights reserved.
//

import UIKit
import WebKit

class MailViewController: UIViewController {
    
    var webView:WKWebView!
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
            webView.frame = self.view.bounds
            view.addSubview(webView)
            let url:URL = URL(string: "https://mail.google.com")!
            let req:URLRequest = URLRequest(url: url)
            webView.load(req)
            
            // Do any additional setup after loading the view.
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            
            // Hide the navigation bar on the this view controller
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}

