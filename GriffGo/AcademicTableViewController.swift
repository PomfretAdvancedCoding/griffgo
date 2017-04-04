//
//  AcademicTableViewController.swift
//  GriffGo
//
//  Created by Tim Baldyga on 3/24/17.
//  Copyright © 2017 Tim Baldyga. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SWXMLHash

var classArray = [String]()
var classID = String()

class AcademicTableViewController: UITableViewController, UITextFieldDelegate {

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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    //Table View Functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countClasses()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassCell", for: indexPath) as! AcademicTableViewCell
        
        if UserData.sharedInstance.faculty {
            var tempClassID = "0" //used to keep track of student count
            var studentCounter = 0
            for classGroup in UserData.sharedInstance.academicData {
                if classGroup.facultyID  == String(UserData.sharedInstance.userID) && !classArray.contains(classGroup.classID) && classGroup.classID != tempClassID {
                    tempClassID = classGroup.classID
                    cell.classBlock.text = classGroup.block
                    cell.className.text = classGroup.name
                    cell.classLocation.text = classGroup.building + " " + classGroup.room
                    classArray.append(classGroup.classID)
                }
                if classGroup.classID == tempClassID {
                    studentCounter += 1
                }
                break
            }
            cell.classTeacher.text = "\(studentCounter) students"
        }
        else {
            for classGroup in UserData.sharedInstance.academicData {
                if classGroup.studentID  == String(UserData.sharedInstance.userID) && !classArray.contains(classGroup.classID) {
                    cell.classBlock.text = classGroup.block
                    cell.className.text = classGroup.name
                    cell.classLocation.text = classGroup.building + " " + classGroup.room
                    classArray.append(classGroup.classID)
                    
                    for faculty in UserData.sharedInstance.facultyData {
                        if faculty.userID == classGroup.facultyID {
                            cell.classTeacher.text = faculty.prefix! + " " + faculty.lastName
                        }
                    }
                    break
                }
            }
        }
        
        return cell
    }
    
    //Function saves the ID of the USER when clicked and opens detialed view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("\(studentData[indexPath.section][indexPath.row])")
        //print(studentData[indexPath.row].userID)
        classID = classArray[indexPath.row]
        print(classID)
        self.performSegue(withIdentifier: "AcademicSegue", sender: nil)
    }
    
    func countClasses() -> Int {
        
        var counter = 0
        //print (String(UserData.sharedInstance.userID))
        //print (data)
        
        if UserData.sharedInstance.faculty {
            for index in UserData.sharedInstance.academicData {
                if index.facultyID  == String(UserData.sharedInstance.userID) {
                    counter += 1
                }
            }
        }
        else {
            for index in UserData.sharedInstance.academicData {
                if index.studentID  == String(UserData.sharedInstance.userID) {
                    counter += 1
                    print (counter)
                }
            }
        }
        return counter
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
