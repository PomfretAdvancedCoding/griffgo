//
//  SecondViewController.swift
//  GriffGo
//
//  Created by Tim Baldyga on 12/1/16.
//  Copyright © 2016 Tim Baldyga. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SWXMLHash

var directoryID = String()

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var candies = [UserData.sharedInstance.studentData]
    var filteredCandies = [UserData.sharedInstance.studentData]
    let searchController = UISearchController(searchResultsController: nil)

    
    //Table View Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserData.sharedInstance.studentData.count
    }
    

    //Function determinds what each row will say
    /* As always table view needs 3 function
     * This is number 2. define the data on the cell
     * display name on the new cell that is going up
     * If the name is exist just show the name
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        //print (UserData.sharedInstance.studentData[indexPath.row].nickName)
        
        if UserData.sharedInstance.studentData[indexPath.row].nickName != ""{
            cell.textLabel?.text = String(UserData.sharedInstance.studentData[indexPath.row].nickName! + " " + UserData.sharedInstance.studentData[indexPath.row].lastName)
        }
        else {
            cell.textLabel?.text = String(UserData.sharedInstance.studentData[indexPath.row].firstName + " " + UserData.sharedInstance.studentData[indexPath.row].lastName)
        }
        
        //cell.textLabel?.text = studentData[indexPath.row].firstName
        return cell
    }
    
    //Function saves the ID of the USER when clicked and opens detialed view
    /* When clicked, use segue to the Directory(the page with face and personal information)
     *
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("\(studentData[indexPath.section][indexPath.row])")
        //print(studentData[indexPath.row].userID)
        directoryID = UserData.sharedInstance.studentData[indexPath.row].userID
        self.performSegue(withIdentifier: "directorySegue", sender: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

