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
    
    @IBAction func logoutButton(_ sender: Any) {
        //Logout user
        UserData.sharedInstance.userID = 0
        self.performSegue(withIdentifier: "logoutSegue", sender: nil)
    }
    
    @IBAction func postButton(_ sender: Any) {
        
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
        
        
        //SweetsTableViewController.loadData()
        
       
        
        //Get Athletic Data
        sportsGet()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

