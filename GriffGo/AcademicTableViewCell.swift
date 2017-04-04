//
//  AcademicTableViewCell.swift
//  GriffGo
//
//  Created by Tim Baldyga on 3/24/17.
//  Copyright © 2017 Tim Baldyga. All rights reserved.
//

import UIKit

class AcademicTableViewCell: UITableViewCell {

    @IBOutlet weak var classBlock: UILabel!
    @IBOutlet weak var classTeacher: UILabel!
    @IBOutlet weak var classLocation: UILabel!
    @IBOutlet weak var className: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class AssignmentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var assignmentName: UILabel!
    @IBOutlet weak var assignmentType: UILabel!
    @IBOutlet weak var assignmentDue: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
