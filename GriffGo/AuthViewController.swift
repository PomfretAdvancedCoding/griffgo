//
//  AuthViewController.swift
//  Master GriffGo
//
//  Created by Tim Baldyga on 12/7/16.
//  Copyright © 2016 Tim Baldyga. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SWXMLHash
import Firebase

//SETUP HERE:
//-------------------------------------------
//Enter the Username and Password of your school's api admin.
let APIUserName = "griffgo-api"
let APIPassword = "73(73L7j&,88938"

//Provide the 3 list ID's for  Student, Faculty and Atheltic data with the following coloumn headers
//Students - Prefix, First Name, Middle Name, Last Name, Nickname, Gender, Graduation Year, Email Address, Student ID, Photo, MobilePhone, Dorm
let StudentListID = "58881"
//Faculty - Prefix,	First Name,	Middle Name, Last Name, Nickname, Email Address, UserID, Photo
let FacultyListID = "58990"
//Athletics - gameID, team, location, title, home, date, time, score, headline, highlights, outcome
let SportsListID = "59307"

let listType = (student: "58881", //Students - Prefix, First Name, Middle Name, Last Name, Nickname, Gender, Graduation Year, Email Address, Student ID, Photo, MobilePhone, Dorm
              faculty: "58990", //Faculty - Prefix,	First Name,	Middle Name, Last Name, Nickname, Email Address, UserID, Photo
              athletic: "59307", //Athletics - gameID, team, location, title, home, date, time, score, headline, highlights, outcome
              academic: "61884",
              assignment: "61885"
)

//--------------------------------------------

var masterToken = String()
var userID = String()
let adminParameters: Parameters = ["format": "json", "password": "\(APIPassword)", "username": "\(APIUserName)"]


typealias FinishedDownload = () -> ()

class AuthViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var loadingIcon: UIActivityIndicatorView!
    @IBOutlet weak var messageBox: UILabel!
    
        
       //Set Master Token
    let tokenParameters: Parameters = ["format": "json",
                                       "password": "\(APIPassword)",
                                       "username": "\(APIUserName)"]
    var user : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButtonOutlet.layer.cornerRadius = 10
        
        //Turns off Auto-Correct for Username and Password
        usernameOutlet.autocorrectionType = .no
        passwordOutlet.autocorrectionType = .no
        
        //Set keyboard delegate
        usernameOutlet.delegate = self
        passwordOutlet.delegate = self
        
        if UserData.sharedInstance.authenticated == true && UserData.sharedInstance.userID != 0 {
            print("Processing Auto-Login...")
            self.processLogin()
        }
    }
    
    //Called when user hits the login Button
    @IBAction func loginButton(_ sender: Any) {
        
        
        //Starts the loading Icon and disables the feilds
        self.loadingIcon.startAnimating()
        self.messageBox.text = "Logging In..."
        //self.usernameOutlet.isEnabled = false
        //self.passwordOutlet .isEnabled = false
        self.loginButtonOutlet.isEnabled = false
        usernameOutlet.resignFirstResponder()
        passwordOutlet.resignFirstResponder()
        
        //Checks if the user accidently entered @pomfretscool.org
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
        
        //Make a request for to authenticate the user
        authRequest(params: ["format": "json","password": "\(APIPassword)","username": "\(APIUserName)"], ifToken: true)
    }
    
    
    //Called to authenticate a user and return either token or userID
    func authRequest (params: Parameters, ifToken: Bool) {
        Alamofire.request("https://pomfretschool.myschoolapp.com/api/authentication/login/", parameters: params).responseJSON { response in
            if let alamoJSON = response.result.value {
                //print("Authentication Response: \(response.result.value)")
                let json = JSON(alamoJSON)
                if json["Token"].string != nil {
                    
                    if ifToken == true {
                        masterToken = json["Token"].string!
                        print("Master Token: \(masterToken)")
                        //Once Token is retrieved, get user ID
                        let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
                            self.authRequest(params: ["format": "json", "password": self.passwordOutlet.text!, "username": self.usernameOutlet.text!], ifToken: false)
                        }
                        
                    }
                    else {
                        let id = json["UserId"].int!
                        userID = String(id)
                        print("Authenticated User ID: \(userID)")
                        //Once user ID is retrived, check if user is in authenticated role
                        self.authCheck(params: ["format": "json", "userID": userID, "t": masterToken])
                    }
                }
                else {
                    if json["ErrorType"].string == "UNAUTHORIZED_ACCESS" {
                        self.messageBox.text = "Invalid Username or Password"
                        self.passwordOutlet.text = ""
                        self.loginButtonOutlet.isEnabled = true
                        self.loadingIcon.stopAnimating()
                        FIRAnalytics.logEvent(withName: "Bad_Credentials", parameters: nil)
                        
                        // add a time out feature to prevent 3 unsuccessful login attempts
                        
                        return
                    }
                    else if json["UserId"].int == nil {
                        self.messageBox.text = "Server Error"
                        self.loginButtonOutlet.isEnabled = true
                        FIRAnalytics.logEvent(withName: "Locked_User", parameters: nil)
                        self.passwordOutlet.text = ""
                        self.loadingIcon.stopAnimating()
                    }
                }
            }
            else {
                //if unable to make request
                self.messageBox.text = "Connection Error"
                self.passwordOutlet.text = ""
                self.loadingIcon.stopAnimating()
                self.loginButtonOutlet.isEnabled = true
                FIRAnalytics.logEvent(withName: "Network_Error", parameters: nil)
            }
        }
        
    }
    
    //Checks if the user is under an authenticated role
    func authCheck(params: Parameters) {
        print ("Credentials Accepted...")
        Alamofire.request("https://pomfretschool.myschoolapp.com/api/role/", parameters: params).responseJSON { response in
            if let alamoJSON = response.result.value {
                //print("Role Authentication Response: \(response.result.value)")
                let json = JSON(alamoJSON)
                var jsonIdx = 0
                
                print ("Role Authorization....")
                repeat {
                    if json[jsonIdx]["RoleName"] == "Faculty" || json[jsonIdx]["RoleName"] == "Administrative Staff"{
                        UserData.sharedInstance.faculty = true
                        UserData.sharedInstance.authenticated = true
                        UserData.sharedInstance.userID = Int(userID)!
                    }
                    else if json[jsonIdx]["RoleName"] == "Student" || json[jsonIdx]["RoleName"] == "Incoming Student" {
                        UserData.sharedInstance.faculty = false
                        UserData.sharedInstance.authenticated = true
                        UserData.sharedInstance.userID = Int(userID)!
                    }
                    //increment by 1
                    jsonIdx += 1
                } while jsonIdx < 30 || UserData.sharedInstance.authenticated == false
                
                //Check if user was unable to be authenticated
                if UserData.sharedInstance.authenticated == false {
                    self.messageBox.text = "Unable to Authorize"
                    self.loginButtonOutlet.isEnabled = true
                    FIRAnalytics.logEvent(withName: "Bad_Token", parameters: nil)
                    self.loadingIcon.stopAnimating()
                }
                else {
                    print("Success: User \(userID) is Authenticated")
                    self.loadingIcon.stopAnimating()
                    self.processLogin() //Log user into the App
                }
            }
            else {
                self.messageBox.text = "Network Error"
                self.loginButtonOutlet.isEnabled = true
                FIRAnalytics.logEvent(withName: "Network_Error", parameters: nil)
            }
        }
    }
    
    //logs user in once they are autheticated.
    func processLogin() {
        self.messageBox.text = "Loading App..."
        DataRetrival.sharedCall.getData()
        let timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { (timer) in
            FIRAnalytics.logEvent(withName: "User_Login", parameters: [
                kFIRParameterItemID : userID as NSObject
                ])
            
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
        //Run dataGet function to call new token and get lists.
        //Start the loading bar? the last list should be
        
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

}
