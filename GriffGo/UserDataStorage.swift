//
//  UserDataStorage.swift
//  
//
//  Created by Tim Baldyga on 12/7/16.
//
//

import Foundation

class UserData {
    
    //Basics
    var userID : Int
    var userIndex : Int
    var firstName : String
    var lastName : String
    var nickName : String
    var faculty : Bool
    var authenticated : Bool
    var userPhoto : String
    var userGreeting : String
    
    var studentData : [(userID: String, firstName: String, lastName: String, nickName: String?, yog: String, email: String, photo: String?, phone : String?, dorm : String?)] = []
    var facultyData : [(userID: String, firstName: String, lastName: String, prefix: String?, email: String, photo: String?)] = []
    var sportsData : [(gameID: String, team: String, location: String, title: String?, home: String, date: String, time: String?,score: String?, headline: String?, highlights: String?, outcome: String?)] = []
    var academicData : [(studentID: String, classID: String, facultyID: String, block: String, name: String, building: String, room: String)] = []
    var assignmentData : [(description: String?, classID: String, assigned: String, due: String, title: String, type: String)] = []
    
    class var sharedInstance : UserData {
        struct Singleton {
            static let instance = UserData()
        }
        
        return Singleton.instance
    }
    
    init() {
        userID = 0
        userIndex = 0
        firstName = ""
        lastName = ""
        nickName = ""
        faculty = false
        authenticated = false
        userPhoto = ""
        userGreeting = ""
        
        let defaults = UserDefaults.standard
        
        userID = defaults.integer(forKey: "userID")
        
        //firstName = defaults.string(forKey: "firstName")!
        //lastName = defaults.string(forKey: "lastName")!
        if defaults.string(forKey: "nickName") != nil{
            nickName = defaults.string(forKey: "nickName")!
        }
        //userPhoto = defaults.string(forKey: "userPhoto")!
        //userGreeting = defaults.string(forKey: "userGreeting")!

        
    }
    
    //This function is called to save the User's ID
    func saveData() {
        // Store in user defaults
        let defaults = UserDefaults.standard
        defaults.set(userID, forKey: "userID")
        defaults.set(nickName, forKey: "nickName")
        defaults.set(firstName, forKey: "firstName")
        defaults.set(lastName, forKey: "lastName")
        defaults.set(userPhoto, forKey: "userPhoto")
        defaults.set(userGreeting, forKey: "userGreeting")
        
        UserDefaults.standard.synchronize()
        print("Saving User Data: \(userID)")
        
    }
    
}
