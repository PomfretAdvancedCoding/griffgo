//
//  weeklyschedulcard.swift
//  GriffGo
//
//  Created by Yves Geyer on 4/18/17.
//  Copyright © 2017 Tim Baldyga. All rights reserved.
//

import UIKit

class weeklyschedulcard: UIViewController {
    
    @IBAction func redweek(_ sender: Any) {
        
        redweek.isHidden = true
        blackweek.isHidden = false
    }
    @IBAction func blackweek(_ sender: Any) {
        redweek.isHidden = false
        blackweek.isHidden = true
    }
    @IBOutlet weak var blackweek: UIButton!
    @IBOutlet weak var redweek: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blackweek.isHidden = true
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
