//
//  MantraCountTableViewCell.swift
//  Sadhana
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

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func stepperChanged(stepper: UIStepper) {
        self.stepperLabel?.text = "Beads count: \(Int(stepper.value))"
        NSUserDefaults.standardUserDefaults().setObject(Int(stepper.value), forKey: standartMantraCount)
    }

}
