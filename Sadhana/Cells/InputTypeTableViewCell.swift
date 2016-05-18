//
//  InputTypeTableViewCell.swift
//  Sadhana
//
//  Created by Roman Slysh on 5/13/16.
//  Copyright © 2016 Roman Slysh. All rights reserved.
//

import UIKit

enum InputTypeEnum: Int {
    case volume = 0
    case tap
    case both
}

class InputTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func segmentedControlChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case InputTypeEnum.volume.rawValue:
            NSUserDefaults.standardUserDefaults().setObject(InputTypeEnum.volume.rawValue, forKey: userInputType)
        case InputTypeEnum.tap.rawValue:
            NSUserDefaults.standardUserDefaults().setObject(InputTypeEnum.tap.rawValue, forKey: userInputType)
        case InputTypeEnum.both.rawValue:
            NSUserDefaults.standardUserDefaults().setObject(InputTypeEnum.both.rawValue, forKey: userInputType)
        default:
            NSUserDefaults.standardUserDefaults().setObject(InputTypeEnum.both.rawValue, forKey: userInputType)
        }
    }
}
