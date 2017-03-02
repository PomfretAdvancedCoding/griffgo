//
//  SportsTableViewController.swift
//  GriffGo
//
//  Created by Tim Baldyga on 12/27/16.
//  Copyright © 2016 Tim Baldyga. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SWXMLHash


var gameID = String()

class SportsTableViewController: UITableViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    //Returns the number of sections in the table view
    // set to return 1(default)
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    //Table View Functions
    /*
     *Makes the number of rows be the number of pieces of data
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserData.sharedInstance.sportsData.count
    }
    
    /*
     *Pulls game info from user data(team, location, outcome, date)
     *attaches location, team, and outcome to table view
     *If the team won the outcome label is green, loss is red, the default is black
     * Date is formated to month day
     * date is attached to view controller
     */

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SportCell", for: indexPath) as! SportsTableViewCell
        
        if UserData.sharedInstance.sportsData[indexPath.row].team != ""{
            cell.teamOutlet?.text = String("@ " + UserData.sharedInstance.sportsData[indexPath.row].location)
            cell.gameOutlet?.text = String(UserData.sharedInstance.sportsData[indexPath.row].team)
            cell.outcomeOutlet?.text = UserData.sharedInstance.sportsData[indexPath.row].outcome
            
            if UserData.sharedInstance.sportsData[indexPath.row].outcome == "Win" {
                cell.outcomeOutlet.textColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
            }
            else if UserData.sharedInstance.sportsData[indexPath.row].outcome == "Loss" {
                cell.outcomeOutlet.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            }
            else {
                cell.outcomeOutlet.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
            
            let rawDate = String(UserData.sharedInstance.sportsData[indexPath.row].date)
            let oldDateFormatter = DateFormatter()
            oldDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let oldDate = oldDateFormatter.date(from: rawDate!)
            
            let newDateFormatter = DateFormatter()
            newDateFormatter.dateFormat = "MMM d"
            
            let goodDate = newDateFormatter.string(from: oldDate!)
            
            cell.dateOutlet?.text = goodDate
        }
        
        return cell
    }
    
    //Function saves the ID of the USER when clicked and opens detialed view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("\(studentData[indexPath.section][indexPath.row])")
        //print(studentData[indexPath.row].userID)
        gameID = UserData.sharedInstance.sportsData[indexPath.row].gameID
        self.performSegue(withIdentifier: "sportsSegue", sender: nil)
        
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
