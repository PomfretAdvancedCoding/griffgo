//
//  SportsDetailViewController.swift
//  GriffGo
//
//  Created by Tim Baldyga on 1/2/17.
//  Copyright © 2017 Tim Baldyga. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SWXMLHash
import StringExtensionHTML
import HTMLString

class SportsDetailViewController: UIViewController {

    @IBOutlet weak var outcomeOutlet: UILabel!
    @IBOutlet weak var teamOutlet: UILabel!
    @IBOutlet weak var scoreOutlet: UILabel!
    @IBOutlet weak var highlightsOutlet: UITextView!
    
    //gets the game data
    func getGame() -> Int {
        for (index, _) in UserData.sharedInstance.sportsData.enumerated() {
            if UserData.sharedInstance.sportsData[index].gameID == gameID {
                return index
            }
        }
        return 0
    }
    
    /*
     *team is attached to label
     * If there is a headline that is attached to the headline, if not then the score is attached
     *outcome is attached
     * Outcome is attached- if it is a WIn it is set to green, loss is set to red, else is black
     *takes away HTML tags and puts the stripped text as the highlight
     *If there is no highlight it is set to "No Highlights😢"
     */

    func loadData(id : Int) {
        
        teamOutlet.text = UserData.sharedInstance.sportsData[id].team
        
        if UserData.sharedInstance.sportsData[id].headline != "" {
            scoreOutlet.text = UserData.sharedInstance.sportsData[id].headline
        }
        else {
            scoreOutlet.text = UserData.sharedInstance.sportsData[id].score
        }
        
        outcomeOutlet.text = UserData.sharedInstance.sportsData[id].outcome
        
        if UserData.sharedInstance.sportsData[id].outcome == "Win" {
            outcomeOutlet.textColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        }
        else if UserData.sharedInstance.sportsData[id].outcome == "Loss" {
            outcomeOutlet.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        }
        else {
            outcomeOutlet.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
        if UserData.sharedInstance.sportsData[id].highlights != "" {
            let text = UserData.sharedInstance.sportsData[id].highlights
            let decodedText = text?.stringByDecodingHTMLEntities
            let strippedText = decodedText?.stringByStrippingHTMLTags
            highlightsOutlet.text = strippedText
        }
        else {
            highlightsOutlet.text = "No highlights... 😢"
            highlightsOutlet.textAlignment = .center
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData(id : getGame())

        // Do any additional setup after loading the view.
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
