//
//  ResourcesViewController.swift
//  GriffGo
//
//  Created by Tim Baldyga on 12/12/16.
//  Copyright © 2016 Tim Baldyga. All rights reserved.
//

import Foundation
import UIKit

var WebURL : String = ""

class ResourcesViewController: UITableViewController {
    
    var names = [String]()
    var identities = [String]()
    var url = [String]()
    
    
    override func viewDidLoad() {
        
        names = ["Sundial Resource Page",
                 "Clubs",
                 "Dining Hall Menu",
                 "Du Pont Library",
                 "Facility Hours",
                 "Griffin Guide",
                 "Important Phone Numbers",
                 "Master Calendar",
                 "Reach",
                 "Red/Black Week Schedule",
                 "Restaurants Nearby"
        ]
        identities = ["a",
                      "a",
                      "a",
                      "a",
                      "e",
                      "a",
                      "g",
                      "a",
                      "a",
                      "a",
                      "k"
        ]
        url = ["https://pomfretschool.myschoolapp.com/app/student#resourceboard",
               "http://www.pomfretschool.org/page/Campus-Life/Clubs--Organizations",
               "http://www.myschooldining.com/ps/?cmd=menus",
               "http://library.pomfretschool.org/main",
               "",
               "https://issuu.com/pomfretschool/docs/2015-2016-griffinguide-8-26-15",
               "",
               "http://www.pomfretschool.org/page/calendar",
               "https://pom.reachboarding.com/",
               "http://www.pomfretschool.org/Page/Academics/Daily-Schedule",
               ""
        ]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        cell?.textLabel!.text = names[indexPath.row]
        
        return cell!
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vcName = identities[indexPath.row]
        WebURL = url[indexPath.row]
        let viewController = storyboard?.instantiateViewController(withIdentifier: vcName)
        self.navigationController?.pushViewController(viewController!, animated: true)
        
    }
    
}

