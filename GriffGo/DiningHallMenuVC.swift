//
//  DiningHallMenuVC.swift
//  GriffGo
//
//  Created by Hayden Galusza on 4/20/17.
//  Copyright © 2017 Tim Baldyga. All rights reserved.
//

import UIKit

class DiningHallMenuVC: UIViewController {

    
    
     @IBOutlet weak var dininghalloutlet: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    
    
    let URL = NSURL(string:"http://docs.google.com/spreadsheets/u/1/d/12s2oXREksS8BN-rYhr8p2RPKkH0pRkz826Ytu8QNSPE/pub?single=true&gid=2&output=html")
    
    dininghalloutlet.loadRequest(NSURLRequest(url: URL! as URL) as URLRequest)
    
    
    
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
