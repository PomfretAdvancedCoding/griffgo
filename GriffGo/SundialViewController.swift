//
//  SundialViewController.swift
//  GriffGo
//
//  Created by Tim Baldyga on 12/13/16.
//  Copyright © 2016 Tim Baldyga. All rights reserved.
//

import UIKit
import WebKit

class SundialViewController: UIViewController {
    
    var webView:WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        webView.frame = self.view.bounds
        view.addSubview(webView)
        let url:URL = URL(string: "https://pomfretschool.myschoolapp.com")!
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
