//
//  weekschedulseguea.swift
//  GriffGo
//
//  Created by Yves Geyer on 4/10/17.
//  Copyright © 2017 Tim Baldyga. All rights reserved.
//

import UIKit

class blackWeekSchedule: UIViewController {

    
    @IBAction func BlackWeekSchedule(_ sender: Any) {
//        let segue = "hello"
//        performSegue(withIdentifier: "RedWeekScheduleSegue", sender: segue)
        dismiss(animated: true, completion: nil)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        if let destination = segue.destination as? redWeekSchedule{
            
            if let weekschedul = sender as? String{
                destination.redWeekSchedule = weekschedul
                
                dismiss(animated: true, completion: nil)
            }
            
        }
    }
    private var _blackWeeklSchedule: String!
    
    var blackWeekScheduleSegue: String{
        get{
            return _blackWeeklSchedule
        }set{
            _blackWeeklSchedule = newValue
        }
    }
    
    
    @IBAction func backBTNPressed(_ sender: Any){
      
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    

   
}
