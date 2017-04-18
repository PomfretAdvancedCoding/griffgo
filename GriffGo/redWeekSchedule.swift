//
//  redWeekSchedule.swift
//  GriffGo
//
//  Created by Yves Geyer on 4/12/17.
//  Copyright © 2017 Tim Baldyga. All rights reserved.
//

import UIKit

class redWeekSchedule: UIViewController {

    @IBAction func BlackWeekSchedule(_ sender: Any) {
        let segue = "hello"
        performSegue(withIdentifier: "BlackWeekSchedule", sender: segue)
    
    
    }
    @IBAction func backBTNPressed(_ sender: Any){
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? blackWeekSchedule{
            
            if let weekschedul = sender as? String{
                destination.blackWeekScheduleSegue = weekschedul
                
            }
            
        }
    }

    private var _redWeekSchedule:String!
    
    
    var redWeekSchedule: String!{
        get{
            return _redWeekSchedule
        }set{
            _redWeekSchedule = newValue
        }
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
