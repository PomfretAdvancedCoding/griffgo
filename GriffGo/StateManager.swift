//
//  StateManager.swift
//  Checklists
//
//  Created by Tim Baldyga on 12/12/16.
//  Copyright © 2016 Tim Baldyga. All rights reserved.
//

import Foundation

class StateManager {
    static let shared = StateManager()
    
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }
    
    func initialize() {
        registerDefaults()
        handleFirstTime()
    }
    
    func resetSelectedChecklistIndex() {
        indexOfSelectedChecklist = -1
    }
    
    private init() {}
    
    private func registerDefaults() {
        let dictionary = ["ChecklistIndex": -1,
                          "FirstTime": true,
                          "ChecklistItemID": 0 ] as [String : Any]
        
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    private func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let coreDataStack = CoreDataStack.shared
        
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime {
            let checklist = Checklist(context: coreDataStack.managedObjectContext)
            checklist.name = "My first list"
            coreDataStack.saveContext()
            
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }

    
    

}
