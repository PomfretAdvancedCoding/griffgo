//
//  ViewControllerSRP2.swift
//  tablemultiview2
//
//  Created by Andrew Bernal on 12/12/16.
//  Copyright © 2016 Peng Jiaman. All rights reserved.
//

import UIKit
import WebKit

class ResourcesWebView: UIViewController {
    var webView:WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        webView.frame = self.view.bounds
        view.addSubview(webView)
        let url:URL = URL(string: WebURL)!
        let req:URLRequest = URLRequest(url: url)
        webView.load(req)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
