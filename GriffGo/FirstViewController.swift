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
    
    @IBAction func logoutButton(_ sender: Any) {
        //Logout user
        UserData.sharedInstance.userID = 0
        self.performSegue(withIdentifier: "logoutSegue", sender: nil)
    }
    
    @IBAction func postButton(_ sender: Any) {
        
    }
    
    /*
     *The profile picture of the student begins to load.
     *The loading icon will pop up first while waiting for the photo to load
     *If the photo is emty string, it will get data from alamofire to load the student's image. The picture will become circular and the loading icon will stop
     */
    
    func picLoader() {
        self.loadingIcon.startAnimating()
        var photo = UserData.sharedInstance.userPhoto
        if photo == "" {
            photo = "large_user2723453_934847.png"
        }
        Alamofire.request("https://bbk12e1-cdn.myschoolcdn.com/ftpimages/14/user/\(photo)").responseImage { response in
            if let image = response.result.value {
                let circularImage = image.af_imageRoundedIntoCircle()
                self.userPic.image = circularImage
                self.loadingIcon.stopAnimating()
            }
        }
        
    }
    /*
     *This will determine the current time of the day and the date using NSDate
     If the time is at the hour, it will display a certain message
     */
    
    
    func timeOfDay() -> String {
        let date = NSDate()
        let calendar = NSCalendar.current
        let hour = calendar.component(.hour, from: date as Date)
        
        if hour > 20 && hour < 22 {
            return "Hope you had a great day "
        }
        else if hour < 3 {
            return "It's getting late "
        }
        else if hour < 12 {
            return "Good morning "
        }
        else if hour < 17 {
            return "Good afternoon "
        }
        else if hour >= 17 {
            return "Good evening "
        }
        else {return "Hello "}
    }
    
    /*
     *This is the code to display the user name in the greetingLabel
     *It can tell where the user is a student or a faculty
     *It gather the data to determine the user's last name and prefix
     *If the user's a student, it will return their nick name
     *This and the timeOfDay label is the greeting.
     
     */
    
    func userGreeting () -> String {
        //UserData.sharedInstance.userGreeting = UserData.sharedInstance.facultyData[index].photo!
        let index = UserData.sharedInstance.userIndex
        if UserData.sharedInstance.isFaculty == true {
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
    /*
     *this determine the date of the day using NSDate
     *This will display in the dateLABEL which is below the greeting label
     
     */
    func date() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        let currentDate = NSDate()
        return dateFormatter.string(from: currentDate as Date)
    }
    
    /*
     *This does not show up on the homescreen.
     *It is used to gather sport games high light from the the pomfretschool alamofire api
     */
    func sportsGet() {
        if masterToken != "" {
            //Student XML
            Alamofire.request("https://pomfretschool.myschoolapp.com/api/list/59307/", parameters: ["format": "xml", "t": masterToken]).responseData { response in
                //print("Response: \(response.response)")
                if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                    //print("Data: \(utf8Text)")
                    let xml = SWXMLHash.parse(utf8Text)
                    self.dataLoader(data: xml)
                }
            }
        }
    }
    
    //Data Loader Function
    /*
     *This put sport highlight into table view cell
     *It get data from user data
     *This display on the sport section of the app
     */
    
    func dataLoader(data: XMLIndexer) {
        //var playerScores: (userIden: [Int], firstName: String, lastName: String?)
        
        for elem in data["ListResult"]["ListItem"].all {
            
            UserData.sharedInstance.sportsData.append((
                gameID: elem["gameID"].element!.text!,
                team: elem["team"].element!.text!,
                location: elem["location"].element!.text!,
                title: elem["title"].element!.text!,
                home: elem["home"].element!.text!,
                date: elem["date"].element!.text!,
                time: elem["time"].element!.text!,
                score: elem["score"].element!.text!,
                headline: elem["headline"].element!.text!,
                highlights: elem["highlights"].element!.text!,
                outcome: elem["outcome"].element!.text!
            ))
        }
        //print (UserData.sharedInstance.sportsData)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load Firebase
        ref = FIRDatabase.database().reference()
        
        //Function to Load User photo
        picLoader()
        
        //SweetsTableViewController.loadData()
        
        //Set Greeting label
        greetingLabel.text = "\(timeOfDay())\(userGreeting())"
        
        //Set the date
        dateLabel.text = "Today is \(date())"
        
        //Get Athletic Data
        sportsGet()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

