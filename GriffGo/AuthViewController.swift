//
//  AuthViewController.swift
//  GriffGo
//
//  Created by Tim Baldyga on 12/7/16.
//  Copyright © 2016 Tim Baldyga. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SWXMLHash
import Firebase

var masterToken = String()

class AuthViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    
    @IBOutlet weak var loadingIcon: UIActivityIndicatorView!
    @IBOutlet weak var messageBox: UILabel!
    
    //Set Master Token
    let tokenParameters: Parameters = ["format": "json", "password": "Griffy1894", "username": "pomfret-api"]
    
    var userID : Int = 0
    var user : String = ""
    
    
    @IBAction func loginButton(_ sender: Any) {
        
        if (usernameOutlet.text?.characters.count)! > 18 {
        if usernameOutlet.text != "" {
        let user = usernameOutlet.text
        let last18 = user?.substring(from:(user?.index((user?.endIndex)!, offsetBy: -18))!)
            if last18 == "@pomfretschool.org" {
                self.messageBox.text = "Remove @pomfretschool.org"
                self.loadingIcon.stopAnimating()
                return
            }
        }
        else {return}
        }
        
        usernameOutlet.resignFirstResponder()
        passwordOutlet.resignFirstResponder()
        
        let loginParameters: Parameters = ["format": "json", "password": passwordOutlet.text!, "username": usernameOutlet.text!]
        loadingIcon.startAnimating()
        if masterToken == "" {
            masterTokenRequest()
            self.messageBox.text = "Fatal Error: Try Again"
            self.passwordOutlet.text = ""
            self.loadingIcon.stopAnimating()
            
            //Analytics
            FIRAnalytics.logEvent(withName: "Bad_Token", parameters: nil)
            
            return
        }
        
        Alamofire.request("https://pomfretschool.myschoolapp.com/api/authentication/login/", parameters: loginParameters).responseJSON { response in
            //print(response.result.value)
            if let alamoJSON = response.result.value {
                print("JSON: \(response.result)")
                let json = JSON(alamoJSON)
                print(response.request)
                print (response.result)
                print (json)
                //If a value for User ID is not found, else auth
                if json["ErrorType"].string == "UNAUTHORIZED_ACCESS" {
                    self.messageBox.text = "Incorrect Username or Password"
                    self.passwordOutlet.text = ""
                    self.loadingIcon.stopAnimating()
                    FIRAnalytics.logEvent(withName: "Bad_Credentials", parameters: nil)
                    return
                }
                else if json["UserId"].int == nil {
                    self.messageBox.text = "Invalid Login"
                    FIRAnalytics.logEvent(withName: "Locked_User", parameters: nil)
                    self.passwordOutlet.text = ""
                    self.loadingIcon.stopAnimating()
                }
                else {
                    self.userID = json["UserId"].int!
                }
                print("User ID: \(self.userID)")
            }
            else {
                self.messageBox.text = "Network Error"
                FIRAnalytics.logEvent(withName: "Network_Error", parameters: nil)
                self.passwordOutlet.text = ""
                self.loadingIcon.stopAnimating()
            }
            
            //If a response was recived and the user was found
            if response.data != nil && self.userID != 0 {
                print("Attempting ID Authetication...")
                print(UserData.sharedInstance.studentData.count)
                //Authenticate User Access and Get Profile Details
                for (index, _) in UserData.sharedInstance.studentData.enumerated() {
                    if UserData.sharedInstance.studentData[index].userID == String(self.userID) {
                        print("Student ID Found!")
                        UserData.sharedInstance.userID = self.userID
                        UserData.sharedInstance.firstName = UserData.sharedInstance.studentData[index].firstName
                        UserData.sharedInstance.lastName = UserData.sharedInstance.studentData[index].lastName
                        UserData.sharedInstance.userPhoto = UserData.sharedInstance.studentData[index].photo!
                        if UserData.sharedInstance.studentData[index].nickName != nil {
                            UserData.sharedInstance.nickName = UserData.sharedInstance.studentData[index].nickName!
                        }
                        else {UserData.sharedInstance.nickName = UserData.sharedInstance.studentData[index].firstName}
                        UserData.sharedInstance.userIndex = index
                        UserData.sharedInstance.isFaculty = false
                        
                        FIRAnalytics.logEvent(withName: "User_Login", parameters: [
                            kFIRParameterItemID : self.userID as NSObject
                        ])
                        
                        self.loadingIcon.stopAnimating()
                        self.performSegue(withIdentifier: "loginSegue", sender: nil)
                        return
                    }
                }
                    for (index, _) in UserData.sharedInstance.facultyData.enumerated() {
                                if UserData.sharedInstance.facultyData[index].userID == String(self.userID) {
                                UserData.sharedInstance.userID = self.userID
                                UserData.sharedInstance.firstName = UserData.sharedInstance.facultyData[index].firstName
                                UserData.sharedInstance.lastName = UserData.sharedInstance.facultyData[index].lastName
                                UserData.sharedInstance.userPhoto = UserData.sharedInstance.facultyData[index].photo!
                                UserData.sharedInstance.userIndex = index
                                UserData.sharedInstance.isFaculty = true
                                
                                FIRAnalytics.logEvent(withName: "User_Login", parameters: [
                                    kFIRParameterItemID : self.userID as NSObject
                                    ])
                                
                                self.loadingIcon.stopAnimating()
                                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                                return
                            }
                    }
                        self.loadingIcon.stopAnimating()
                        self.messageBox.text = "Access not avalible"
            }
        }
    }
    
    //Data Loader Function
    func dataLoader(data: XMLIndexer, type: String) {
        //var playerScores: (userIden: [Int], firstName: String, lastName: String?)
        
        if type == "student" {
            for elem in data["ListResult"]["ListItem"].all {
                //print(elem)
                
                //Comment this line to enable the Test user:
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
        }
        else if type == "faculty" {
            for elem in data["ListResult"]["ListItem"].all {
                //print(elem)
                UserData.sharedInstance.facultyData.append((
                    userID: elem["UserID"].element!.text!,
                    firstName: elem["FirstName"].element!.text!,
                    lastName: elem["LastName"].element!.text!,
                    prefix: elem["Prefix"].element!.text!,
                    email: elem["EmailAddress"].element!.text!,
                    photo: elem["Photo"].element!.text!
                ))
            }
            //Once all data is loaded, the system checks the current user
            loggedinCheck()
        }
        else {print("List Error")}
        
    }
    
    func masterTokenRequest () {
        self.loadingIcon.startAnimating()
        //Get Master Token Request
        Alamofire.request("https://pomfretschool.myschoolapp.com/api/authentication/login/", parameters: tokenParameters).responseJSON { response in
            if let alamoJSON = response.result.value {
                print("Master Token Response: \(response.response)")
                let json = JSON(alamoJSON)
                if json["Token"].string != nil {
                    masterToken = json["Token"].string!
                    print("Master Token: \(masterToken)")
                    self.listRequest(listID: "58881", type: "student")
                    self.listRequest(listID: "58990", type: "faculty")
                }
                else {
                    //If Token is blank for some reason...
                    
                    self.messageBox.text = "Server Error"
                    FIRAnalytics.logEvent(withName: "Bad_Token", parameters: nil)
                    self.loadingIcon.stopAnimating()
                    //Try to log in the User anyway *DANGER*
                    if UserData.sharedInstance.userID != 0 {self.performSegue(withIdentifier: "loginSegue", sender: nil)} else {return}
                }
            }
            else {
                self.messageBox.text = "Network Error"
                FIRAnalytics.logEvent(withName: "Network_Error", parameters: nil)
            }
        }
    }
    
    func listRequest(listID: String, type: String) {
        //Get user data lists
        if masterToken != "" {
            //Student XML
            Alamofire.request("https://pomfretschool.myschoolapp.com/api/list/\(listID)/", parameters: ["format": "xml", "t": masterToken]).responseData { response in
                if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                    //print("Data: \(utf8Text)")
                    let xml = SWXMLHash.parse(utf8Text)
                    self.dataLoader(data: xml, type: type)
                    self.loadingIcon.stopAnimating()
                }
            }
        }
    }
    
    func loggedinCheck() {
        if UserData.sharedInstance.userID != 0 {
            print(UserData.sharedInstance.userID)
            self.userID = UserData.sharedInstance.userID
            for (index, _) in UserData.sharedInstance.studentData.enumerated() {
                if UserData.sharedInstance.studentData[index].userID == String(self.userID) {
                    //TODO: Cleanup the data locations
                    UserData.sharedInstance.userID = self.userID
                    UserData.sharedInstance.firstName = UserData.sharedInstance.studentData[index].firstName
                    UserData.sharedInstance.lastName = UserData.sharedInstance.studentData[index].lastName
                    UserData.sharedInstance.userPhoto = UserData.sharedInstance.studentData[index].photo!
                    UserData.sharedInstance.userIndex = index
                    UserData.sharedInstance.isFaculty = false
                    
                    FIRAnalytics.logEvent(withName: "User_Login", parameters: [
                        kFIRParameterItemID : self.userID as NSObject
                        ])
                    
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    return
                }
            }
            for (index, _) in UserData.sharedInstance.facultyData.enumerated() {
                if UserData.sharedInstance.facultyData[index].userID == String(self.userID) {
                    //TODO: Cleanup the data locations
                    UserData.sharedInstance.userID = self.userID
                    UserData.sharedInstance.firstName = UserData.sharedInstance.facultyData[index].firstName
                    UserData.sharedInstance.lastName = UserData.sharedInstance.facultyData[index].lastName
                    UserData.sharedInstance.userPhoto = UserData.sharedInstance.facultyData[index].photo!
                    UserData.sharedInstance.userIndex = index
                    UserData.sharedInstance.isFaculty = true
                    
                    FIRAnalytics.logEvent(withName: "User_Login", parameters: [
                        kFIRParameterItemID : self.userID as NSObject
                        ])
                    print("Auto-Login Enabled")
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    return
                }
                self.messageBox.text = "Please log in"
            }
            self.loadingIcon.stopAnimating()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Turns off Auto-Correct for Username and Password
        usernameOutlet.autocorrectionType = .no
        passwordOutlet.autocorrectionType = .no
        
        usernameOutlet.delegate = self
        passwordOutlet.delegate = self
        
        //This function Gets a Token and Generates a list of users permited in the system from Sundial.
        masterTokenRequest()

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameOutlet.resignFirstResponder()
        passwordOutlet.resignFirstResponder()
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
