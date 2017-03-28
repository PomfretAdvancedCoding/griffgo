//
//  DirectoryViewController.swift
//  GriffGo
//
//  Created by Tim Baldyga on 12/8/16.
//  Copyright © 2016 Tim Baldyga. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SWXMLHash
import Firebase
import AlamofireImage


class DirectoryViewController: UIViewController {

    @IBOutlet weak var dormOutlet: UILabel!
    @IBOutlet weak var classOutlet: UILabel!
    @IBOutlet weak var nameOutlet: UILabel!
    @IBOutlet weak var loadingIcon: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var emailOutlet: UIButton!
    @IBOutlet weak var phoneOutlet: UIButton!
    
    var email : String = ""
    var phone : String = ""
    var dorm : String = "No Dorm"
    
    @IBAction func emailButton(_ sender: Any) {
        let url = NSURL(string: "mailto:\(email)")
        UIApplication.shared.openURL(url as! URL)
    }
    @IBAction func TellCall(_ sender: Any) {
        let url = NSURL(string: "tel://\(phone)")
        UIApplication.shared.openURL(url as! URL)
    }

    /* Get the User's information
     * using loop for to find the information then return the right one
     *
     *
     */
    func getUser() -> Int {
        for (index, _) in UserData.sharedInstance.studentData.enumerated() {
            if UserData.sharedInstance.studentData[index].userID == directoryID {
                return index
            }
        }
        return 0
    }
    /* Show the information on the screen
     * get the image if can't find use Griffing picture instead
     * show first + lastname
     * show class
     * show dorm
     * show student's number if the user is faculty
     *
     */
    func loadData(id : Int) {
        
        self.loadingIcon.startAnimating()
        var photo = UserData.sharedInstance.studentData[id].photo!
        if photo == "" {
            photo = "large_user2723453_934847.png"
        }
        Alamofire.request("https://bbk12e1-cdn.myschoolcdn.com/ftpimages/14/user/\(photo)").responseImage { response in
            
            if let image = response.result.value {
                let circularImage = image.af_imageRoundedIntoCircle()
                self.imageView.image = circularImage
                self.loadingIcon.stopAnimating()
            }
        }
        
        nameOutlet.text = String(
            UserData.sharedInstance.studentData[id].firstName + " " +
                UserData.sharedInstance.studentData[id].lastName
        )
        classOutlet.text = "Class of \(UserData.sharedInstance.studentData[id].yog)"
        self.email = String(UserData.sharedInstance.studentData[id].email)
        
        if UserData.sharedInstance.studentData[id].dorm != nil {
            dorm = UserData.sharedInstance.studentData[id].dorm!
        }
        
        if UserData.sharedInstance.isFaculty == true {
            self.phone = UserData.sharedInstance.studentData[id].phone!
            
        }
        
        emailOutlet.setTitle( email , for: .normal )
        phoneOutlet.setTitle( phone , for: .normal )
        dormOutlet.text = dorm
    }
    /*  Call the functions above
     *  Call loadData with the data from getUser
     *
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData(id : getUser())
        
        //load student directory list (userID, name, year, dorm, advisor)
        //apppy properties
        //load image and data
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
}

}
/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */
