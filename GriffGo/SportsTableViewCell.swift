//
//  SportsTableViewCell.swift
//  GriffGo
//
//  Created by Tim Baldyga on 1/2/17.
//  Copyright © 2017 Tim Baldyga. All rights reserved.
//

import UIKit

class SportsTableViewCell: UITableViewCell {

    @IBOutlet weak var outcomeOutlet: UILabel!
    @IBOutlet weak var gameOutlet: UILabel!
    @IBOutlet weak var teamOutlet: UILabel!
    @IBOutlet weak var dateOutlet: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
