//
//  FirstViewController.swift
//  GriffGo
//
//  Created by Tim Baldyga on 12/1/16.
//  Copyright © 2016 Tim Baldyga. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SWXMLHash
import Firebase


class FirstViewController: UIViewController {
    
    var ref: FIRDatabaseReference!

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var userPic: UIImageView!
    @IBOutlet weak var loadingIcon: UIActivityIndicatorView!
    
    @IBOutlet weak var greetingBoxView: UIView!
    @IBOutlet weak var scheduleBoxView: UIView!
    
    @IBAction func logoutButton(_ sender: Any) {
        //Logout user
        //TODO: Delete all User Data
        UserData.sharedInstance.academicData.removeAll()
        UserData.sharedInstance.userID = 0
        self.performSegue(withIdentifier: "logoutSegue", sender: nil)
    }
    
    @IBAction func postButton(_ sender: Any) {
        
    }
    
    func picLoader() {
        self.loadingIcon.startAnimating()
        var photo = UserData.sharedInstance.userPhoto
        if photo == "" {
            photo = "large_user2723453_934847.png"
        }
        Alamofire.request("https://bbk12e1-cdn.myschoolcdn.com/ftpimages/14/user/\(photo)").responseImage { response in
            if let image = response.result.value {
                let circularImage = image.af_imageRounded(withCornerRadius: 15)
                
                
                self.userPic.image = circularImage
                self.loadingIcon.stopAnimating()
            }
        }

    }
    
    func timeOfDay() -> String {
        let date = NSDate()
        let calendar = NSCalendar.current
        let hour = calendar.component(.hour, from: date as Date)
        
        if hour > 20 && hour < 22 {
            return masterToken
        }
        else if hour < 3 {
            return masterToken
        }
        else if hour < 12 {
            return masterToken
        }
        else if hour < 17 {
            return masterToken
        }
        else if hour >= 17 {
            return masterToken
        }
        else {return masterToken}
    }
    
    func userGreeting () -> String {
        //UserData.sharedInstance.userGreeting = UserData.sharedInstance.facultyData[index].photo!
        let index = UserData.sharedInstance.userIndex
        if UserData.sharedInstance.faculty == true {
            let greeting = String(
                UserData.sharedInstance.facultyData[index].prefix!
                + " " +
                UserData.sharedInstance.facultyData[index].lastName
            )
            return greeting!
        }
        else {
            return UserData.sharedInstance.nickName
        }
    }
    
    func date() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        let currentDate = NSDate()
        return dateFormatter.string(from: currentDate as Date)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //top view corner radius
        let boxModelRadius: CGFloat = 15
        greetingBoxView.layer.cornerRadius = boxModelRadius
        scheduleBoxView.layer.cornerRadius = boxModelRadius
        
        
        
        
        
        //Use this to change who you are...
        //UserData.sharedInstance.userID = 0
        
        //Checks if user is authenticated
        if UserData.sharedInstance.authenticated == false {
            UserData.sharedInstance.userID = 0
            self.performSegue(withIdentifier: "logoutSegue", sender: nil)
        }
        
        //Load Firebase
        ref = FIRDatabase.database().reference()
        
        //Function to Load User photo
        picLoader()
        
        //SweetsTableViewController.loadData()
        
        //Set Greeting label
        greetingLabel.text = "\(timeOfDay())\(userGreeting())"
        
        //Set the date
        dateLabel.text = " \(date())"
        
        //Get Athletic Data
        //sportsGet()
        
        //sportsLabel.text =
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

// #b02033

