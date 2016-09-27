//
//  MantraCountTableViewCell.swift
//  PressToCount
//
//  Created by Roman Slysh on 5/11/16.
//  Copyright © 2016 Roman Slysh. All rights reserved.
//

import UIKit

class MantraCountTableViewCell: UITableViewCell {

    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var stepperLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stepper.maximumValue = 1000
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func stepperChanged(_ stepper: UIStepper) {
        self.stepperLabel?.text = "Repeat's count: ".localized + "\(Int(stepper.value))"
    }

}
