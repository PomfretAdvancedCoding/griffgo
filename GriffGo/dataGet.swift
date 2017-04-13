//
//  dataGet.swift
//  GriffGo
//
//  Created by Tim Baldyga on 3/21/17.
//  Copyright © 2017 Tim Baldyga. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import SWXMLHash
import Firebase

class DataRetrival {
    
    class var sharedCall : DataRetrival {
        struct Singleton {
            static let instance = DataRetrival()
        }
        
        return Singleton.instance
    }
    
    //Function that retrives and loads data.
    func getData() {
        print("Launching Data Sync...")
        self.listRequest(listID: listType.student, requestAmt: 0, success: { () -> Void in
            print("Student Data Completed...")
            let timer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { (timer) in
                self.listRequest(listID: listType.faculty, requestAmt: 0, success: { () -> Void in
                    print("Faculty Data Completed...")
                    //Call to set user index here
                    if UserData.sharedInstance.userID != 0 {
                        UserData.sharedInstance.userIndex = self.getUserIndex()
                    }
                    let timer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { (timer) in
                        self.listRequest(listID: listType.athletic, requestAmt: 0, success: { () -> Void in
                            print("Atheltic Data Completed...")
                            let timer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { (timer) in
                                self.listRequest(listID: listType.academic, requestAmt: 0, success: { () -> Void in
                                    print("Academic Data Completed...")
                                    let timer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { (timer) in
                                        self.listRequest(listID: listType.assignment, requestAmt: 0, success: { () -> Void in
                                            print("Assignment Data Completed....")
                                            print("Saving Data Fetched...")
                                            //Save Data Here....UserData.saveData()
                                        })
                                    }
                                })
                            }
                    
                        })
                    }
                })
            }
        })
    }
    
    //Function that requests a list
    func listRequest (listID: String, requestAmt: Int, success: @escaping () -> Void) { //Shoulds Each list call generate a token?
        Alamofire.request("https://pomfretschool.myschoolapp.com/api/authentication/login/", parameters: adminParameters).responseJSON { response in
            if let alamoJSON = response.result.value {
                //print("Authentication Response: \(response.result.value)")
                let json = JSON(alamoJSON)
                if json["Token"].string != nil {
                    masterToken = json["Token"].string!
                    //print("Master Token: \(masterToken)")
                    if requestAmt < 3 {
                        Alamofire.request("https://pomfretschool.myschoolapp.com/api/list/\(listID)/", parameters: ["format": "xml", "t": masterToken]).responseData { response in
                            //print("Response: \(response.response)")
                            if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                                //print("Data: \(utf8Text)")
                                if String(utf8Text.characters.prefix(12)) == "<ListResult>" {
                                    //Successfull List Call...process data
                                    let xml = SWXMLHash.parse(utf8Text)
                                    self.listProcessor(list: listID, data: xml)
                                    success()
                                }
                                else if String(utf8Text.characters.prefix(5)) == "<html>" {
                                    let timer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { (timer) in
                                        self.listRequest(listID: listID, requestAmt: requestAmt+1, success: { () -> Void in success() })
                                    }
                                }
                                else {
                                    self.listRequest(listID: listID, requestAmt: requestAmt+1, success: { () -> Void in success() })
                                }
                            }
                            //TODO: Error Reporting
                        }

                    }
                    //If the list was unabled to be called
                    else {
                        print("List \(listID) was unable to be retrieved")
                        FIRAnalytics.logEvent(withName: "User_Login", parameters: [
                            kFIRParameterItemID : listID as NSObject
                            ])
                        success()
                    }
                }
                else {
                    if json["ErrorType"].string == "UNAUTHORIZED_ACCESS" {
                        FIRAnalytics.logEvent(withName: "Bad_Credentials", parameters: nil)
                        success()
                    }
                    else if json["UserId"].int == nil {
                        FIRAnalytics.logEvent(withName: "Locked_User", parameters: nil)
                        success()
                    }
                }
            }
            else {
                FIRAnalytics.logEvent(withName: "Network_Error", parameters: nil)
                success()
            }
        }
        
    }
    
    //Takes Data and list type to process and save data into the app.
    func listProcessor (list: String, data: XMLIndexer) {
        switch (list) {
        case listType.student:
            print("Processing Students..")
            for elem in data["ListResult"]["ListItem"].all {
                //print(elem)
                
                //Uncomment this line to disable the Test user:
                //if elem["StudentID"].element!.text! == "2723453" {continue}
                
                UserData.sharedInstance.studentData.append((
                    userID: elem["StudentID"].element!.text!,
                    firstName: elem["FirstName"].element!.text!,
                    lastName: elem["LastName"].element!.text!,
                    nickName: elem["Nickname"].element!.text!,
                    yog: elem["GraduationYear"].element!.text!,
                    email: elem["EmailAddress"].element!.text!,
                    photo: elem["Photo"].element!.text!,
                    phone: elem["MobilePhone"].element!.text!,
                    dorm: elem["Dorm"].element!.text!
                ))
            }
            
        case listType.faculty:
            print("Processing Faculty...")
            for elem in data["ListResult"]["ListItem"].all {
                UserData.sharedInstance.facultyData.append((
                    userID: elem["UserID"].element!.text!,
                    firstName: elem["FirstName"].element!.text!,
                    lastName: elem["LastName"].element!.text!,
                    prefix: elem["Prefix"].element!.text!,
                    email: elem["EmailAddress"].element!.text!,
                    photo: elem["Photo"].element!.text!
                ))
            }
            
        case listType.athletic:
            print("Processing Athletics...")
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
            
        case listType.academic:
            print("Processing Academics...")
            //print(data)
            for elem in data["ListResult"]["ListItem"].all {
                UserData.sharedInstance.academicData.append((
                    studentID: elem["StudentUserID"].element!.text!,
                    classID: elem["GroupID"].element!.text!,
                    facultyID: elem["FacultyUserID"].element!.text!,
                    block: elem["Block"].element!.text!,
                    name: elem["CourseTitle"].element!.text!,
                    building: elem["BuildingName"].element!.text!,
                    room: elem["RoomNumber"].element!.text!
                ))
            }
            
        case listType.assignment:
            print("Processing Assignments...")
            for elem in data["ListResult"]["ListItem"].all {
                UserData.sharedInstance.assignmentData.append((
                    description: elem["Assignment"].element!.text!,
                    classID: elem["GroupId"].element!.text!,
                    assigned: elem["DateAssigned"].element!.text!,
                    due: elem["DateDue"].element!.text!,
                    title: elem["AssignmentBrief"].element!.text!,
                    type: elem["AssignmentType"].element!.text!
                ))
            }
            
        default:
            print("List Processing Error")
        }
    }
    
    //Finds the user ID in the Faculty or student list and returns the index.
    func getUserIndex() -> Int {
        if UserData.sharedInstance.faculty {
            for (index, _) in UserData.sharedInstance.facultyData.enumerated() {
                if UserData.sharedInstance.facultyData[index].userID == String(UserData.sharedInstance.userID) {
                    UserData.sharedInstance.firstName = UserData.sharedInstance.facultyData[index].firstName
                    UserData.sharedInstance.lastName = UserData.sharedInstance.facultyData[index].lastName
                    UserData.sharedInstance.userPhoto = UserData.sharedInstance.facultyData[index].photo!
                    return(index)
                }
            }
        }
        else {
            for (index, _) in UserData.sharedInstance.studentData.enumerated() {
                if UserData.sharedInstance.studentData[index].userID == String(UserData.sharedInstance.userID) {
                    UserData.sharedInstance.firstName = UserData.sharedInstance.studentData[index].firstName
                    UserData.sharedInstance.lastName = UserData.sharedInstance.studentData[index].lastName
                    UserData.sharedInstance.userPhoto = UserData.sharedInstance.studentData[index].photo!
                    return(index)
                }
            }
        }
        //If user cannot be found in lists, unauthenticate user...
        UserData.sharedInstance.authenticated = false
        return(0)
    }
}
