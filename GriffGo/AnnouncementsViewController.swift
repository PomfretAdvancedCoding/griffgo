//
//  SweetsTableViewController.swift
//  pomfretAPP
//
//  Created by Tim Baldyga on 12/9/16.
//  Copyright © 2016 Tim Baldyga. All rights reserved.
//

import UIKit
import CloudKit

let container: CKContainer =  CKContainer.default()
let publicDB: CKDatabase = container.publicCloudDatabase

class SweetsTableViewController: UITableViewController, UITextFieldDelegate {
    
    var announcements = [CKRecord]()
    var refresh: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Pull to load announcements")
        refresh.addTarget(self, action:  #selector(SweetsTableViewController.loadData), for: .valueChanged)
        
        self.tableView.addSubview(refresh)
        
        loadData()
    }
    
    func loadData () {
        print("Loading Announcements...")
        announcements = [CKRecord]()
        let publicData = CKContainer.default().publicCloudDatabase
        let query = CKQuery(recordType: "Announcement", predicate: NSPredicate(format: "TRUEPREDICATE", argumentArray: nil))
        query.sortDescriptors =  [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        publicDB.perform(query, inZoneWith:  nil, completionHandler: { (results:[CKRecord]?, error:Error?) -> Void in
            if let Announcements = results {
                self.announcements = Announcements
                DispatchQueue.main.async(execute: { () -> Void in
                    self.tableView.reloadData()
                    self.refresh.endRefreshing()
                })
            }
        })
        print(announcements.count)
    }

    @IBAction func infoButton(_ sender: Any) {
        let alert = UIAlertController(title: "Announcements Guide",
                                      message: "Announcements are like you're sending an email to the whole school. Once you post an announcement you cannot remove it. Watch what you say! Announcements are monitored by Faculty. Posts can only take one line of space, try to keep them less than 40 characters.",
                                      preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Got it", style: .cancel, handler: nil))
        
        self.present(alert, animated: false, completion: nil)
    }
    
    @IBAction func sendAnnounement(_ sender: Any) {
        let alert = UIAlertController(title: "Post Announcement", message: "Please read the guide first", preferredStyle: .alert)
        
        alert.addTextField { (textField:UITextField) -> Void in
            textField.placeholder = "Your announcement"
            textField.delegate = self
        }
        
        func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
            let length = textField.text?.characters.count
            if length! >= 10 && range.length == 0 {
                return false
            }
            return true
        }
        
        alert.addAction(UIAlertAction(title: "Send", style: .default, handler: { (action:UIAlertAction) -> Void in
            let textfield = alert.textFields!.first!
            
            if textfield.text != "" {
                let newAnnouncement = CKRecord(recordType: "Announcement")
                //let query = CKQuery(recordType: EstablishmentType, predicate: locationPredicate)
                
                newAnnouncement["content"] = textfield.text as CKRecordValue?
                
                if UserData.sharedInstance.faculty == true {
                    let greeting = String(
                        UserData.sharedInstance.facultyData[UserData.sharedInstance.userIndex].prefix!
                            + " " +
                            UserData.sharedInstance.lastName
                    )
                    newAnnouncement["name"] = greeting as CKRecordValue?
                }
                else {
                    newAnnouncement["name"] = UserData.sharedInstance.nickName + " " + UserData.sharedInstance.lastName as CKRecordValue?
                }
                
                let publicData = CKContainer.default().publicCloudDatabase
                publicData.save(newAnnouncement, completionHandler: { (record:CKRecord?, error:Error?) -> Void in
                    if error == nil{
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.tableView.beginUpdates()
                            self.announcements.insert(newAnnouncement, at: 0)
                            let indexPath = NSIndexPath(row:  0, section:  0)
                            self.tableView.insertRows(at: [indexPath as IndexPath], with: .top)
                            self.tableView.endUpdates()
                        
                    })
                    }
                    
                })
            }
        }))
        
       alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: false, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

     override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return announcements.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomFeedCell

        if announcements.count == 0 {
            return cell
        }
        
        let announcement = announcements[indexPath.row]
        
        if let announcementContent = announcement["content"] as? String {
            let postName = announcement["name"] as? String
            let dateFormat = DateFormatter()
            //dateFormat.dateFormat = "MM/dd/yyyy"
            dateFormat.dateFormat = "MMM d @ h:mm a"
            let dateString = dateFormat.string(from: announcement.creationDate!)
            
            //cell.textLabel?.text = announcementContent
            //cell.detailTextLabel?.text = dateString
            cell.postOutlet?.text = announcementContent
            cell.userOutlet?.text = postName
            cell.dateOutlet?.text = dateString

        }
        
        
        return cell
    }

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

