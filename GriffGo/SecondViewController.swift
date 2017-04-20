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

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var candies = UserData.sharedInstance.studentData
    var filteredCandies = UserData.sharedInstance.studentData
    
    var searchController : UISearchController!
    var resultController = UITableViewController()
    
    var inSearchMode = false
    
    
    //Table View Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inSearchMode{
            // not working_many useless cell
            return filteredCandies.count
        }
        else{
            // working
            return candies.count
        }
    }
    
    
    //Function determinds what each row will say
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("this is index path")
        print(indexPath.count)
        let cell = UITableViewCell()
        
        if inSearchMode{
            if indexPath.row<filteredCandies.count{
                
                
                if filteredCandies[indexPath.row].nickName != ""{
                    cell.textLabel?.text = String(filteredCandies[indexPath.row].nickName! + " " + filteredCandies[indexPath.row].lastName)
                }
                else {
                    cell.textLabel?.text = String(filteredCandies[indexPath.row].firstName + " " + filteredCandies[indexPath.row].lastName)
                }
            }
            
        }
        else{
            if filteredCandies[indexPath.row].nickName != ""{
                cell.textLabel?.text = String(filteredCandies[indexPath.row].nickName! + " " + filteredCandies[indexPath.row].lastName)
            }
            else {
                cell.textLabel?.text = String(filteredCandies[indexPath.row].firstName + " " + filteredCandies[indexPath.row].lastName)
            }        }
        
        return cell
    }
    
    //Function saves the ID of the USER when clicked and opens detialed view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if inSearchMode{
            
            if indexPath.row<filteredCandies.count{
                
                directoryID = filteredCandies[indexPath.row].userID
                self.performSegue(withIdentifier: "directorySegue", sender: nil)
                
            }
        }
        else{
            directoryID = candies[indexPath.row].userID
            self.performSegue(withIdentifier: "directorySegue", sender: nil)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            
        }
        else {
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased()
            print(lower)
            
            // name filter
            filteredCandies = candies.filter({$0.firstName.lowercased().range(of: lower) != nil}) + candies.filter({$0.lastName.lowercased().range(of: lower) != nil}) + candies.filter({$0.nickName?.lowercased().range(of: lower) != nil})
            
            
            //first and nick name check
            var index = 0
            var index2 = 0
            while index<filteredCandies.count{
                index2 = index+1
                while index2<filteredCandies.count{
                    if filteredCandies[index].userID==filteredCandies[index2].userID {
                        
                        filteredCandies.remove(at: index2)
                        
                    }
                    else{
                        index2+=1
                    }
                    
                }
                index+=1
            }
            
            
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

