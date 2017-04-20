//
//  FirstViewController.swift
//  GriffGo
//
//  Created by Tim Baldyga on 12/1/16.
//  Copyright © 2016 Tim Baldyga. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SWXMLHash
import Firebase

import CoreLocation


class FirstViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var currentWeather: CurrentWeather!
    var forecast: Forecast!
    var forecasts = [Forecast]()
    
    
    var ref: FIRDatabaseReference!

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var userPic: UIImageView!
    @IBOutlet weak var loadingIcon: UIActivityIndicatorView!
    // @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var greetingBoxView: UIView!
    @IBOutlet weak var scheduleBoxView: UIView!
    
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    
    
    
    @IBAction func logoutButton(_ sender: Any) {
        //Logout user
        //TODO: Delete all User Data
        UserData.sharedInstance.academicData.removeAll()
        UserData.sharedInstance.userID = 0
        self.performSegue(withIdentifier: "logoutSegue", sender: nil)
    }
    
    @IBAction func postButton(_ sender: Any) {
        
    }
    
    let formatter = DateFormatter()
    let userCleander = Calendar.current;
    let requestedComponent : Set<Calendar.Component> = [
        Calendar.Component.month,
        Calendar.Component.day,
        Calendar.Component.hour,
        Calendar.Component.minute,
        Calendar.Component.second
    ]
    
//    func timePrinter() -> Void {
//        let time = timeCalculator(dateFormat: "MM/dd/yyyy HH:mm:ss a", endTime: "05/28/2017 20:00:00 a")
//        timeLabel.text = "\(time.month!) Months \(time.day!) Days"
//    }
//    
//    func timeCalculator(dateFormat: String, endTime: String, startTime: Date = Date()) -> DateComponents {
//        formatter.dateFormat = dateFormat
//        let _startTime = startTime
//        let _endTime = formatter.date(from: endTime)
//        
//        let timeDifference = userCleander.dateComponents(requestedComponent, from: _startTime, to: _endTime!)
//        return timeDifference
//    }

    
    func picLoader() {
        self.loadingIcon.startAnimating()
        var photo = UserData.sharedInstance.userPhoto
        if photo == "" {
            photo = "large_user2723453_934847.png"
        }
        
        Alamofire.request("https://bbk12e1-cdn.myschoolcdn.com/ftpimages/14/user/\(photo)").responseImage { response in
            if let image = response.result.value {
                let circularImage = image.af_imageRounded(withCornerRadius: 15)
                
                
                self.userPic.image = circularImage
                self.loadingIcon.stopAnimating()
            }
        }

    }
    
    func timeOfDay() -> String {
        let date = NSDate()
        let calendar = NSCalendar.current
        let hour = calendar.component(.hour, from: date as Date)
        
        if hour > 20 && hour < 22 {
            return "Hope you had a great day "
        }
        else if hour < 3 {
            return "It's getting late "
        }
        else if hour < 12 {
            return "Good morning "
        }
        else if hour < 17 {
            return "Good afternoon "
        }
        else if hour >= 17 {
            return "Good evening "
        }
        else {return "Hello "}
    }
    
    func userGreeting () -> String {
        //UserData.sharedInstance.userGreeting = UserData.sharedInstance.facultyData[index].photo!
        let index = UserData.sharedInstance.userIndex
        if UserData.sharedInstance.faculty == true {
            let greeting = String(
                UserData.sharedInstance.facultyData[index].prefix!
                + " " +
                UserData.sharedInstance.facultyData[index].lastName
            )
            return greeting!
        }
        else {
            return UserData.sharedInstance.firstName // .nickName returns an empty string...
        }
    }
    
    func date() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        let currentDate = NSDate()
        return dateFormatter.string(from: currentDate as Date)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationAuthStatus()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()

        
        currentWeather = CurrentWeather()
        updateMainUI()

        
        
        //  let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timePrinter), userInfo: nil, repeats: true)

        
        
        //top view corner radius
        let boxModelRadius: CGFloat = 15
        greetingBoxView.layer.cornerRadius = boxModelRadius
        scheduleBoxView.layer.cornerRadius = boxModelRadius
        
        
        
        
        
        //Use this to change who you are...
        //UserData.sharedInstance.userID = 0
        
        //Checks if user is authenticated
        if UserData.sharedInstance.authenticated == false {
            UserData.sharedInstance.userID = 0
            self.performSegue(withIdentifier: "logoutSegue", sender: nil)
        }
        
        //Load Firebase
        ref = FIRDatabase.database().reference()
        
        //Function to Load User photo
        picLoader()
        
        //SweetsTableViewController.loadData()
        
        //Set Greeting label
        greetingLabel.text = "Welcome, \(userGreeting())"
        //greetingLabel.text = "\(userGreeting())"
        
        //Set the date
        dateLabel.text = " \(date())"
        
        //Get Athletic Data
        //sportsGet()
        
        //sportsLabel.text =
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            currentWeather.downloadWeatherDetails {
                self.downloadForecastData {
                    self.updateMainUI()
                }
            }
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus()
        }
    }
    
    func downloadForecastData(completed: @escaping DownloadComplete) {
        //Downloading forecast weather data for TableView
        Alamofire.request(FORECAST_URL).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                    
                    for obj in list {
                        let forecast = Forecast(weatherDict: obj)
                        self.forecasts.append(forecast)
                        print(obj)
                    }
                    self.forecasts.remove(at: 0)
                    //self.tableView.reloadData()
                }
            }
            completed()
        }
    }
    
    func updateMainUI() {
        dateLabel.text = currentWeather.date
        currentTempLabel.text = "\(currentWeather.currentTemp)°"
        //currentWeatherTypeLabel.text = currentWeather.weatherType
        //locationLabel.text = currentWeather.cityName
        currentWeatherImage.image = UIImage(named: currentWeather.weatherType)
    }

    
    


}

// #b02033

