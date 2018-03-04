//
//  ThemeTableViewCell.swift
//  PressToCount
//
//  Created by Roman Slysh on 3/4/18.
//  Copyright © 2018 Roman Slysh. All rights reserved.
//

import UIKit

class ThemeTableViewCell: UITableViewCell {
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var themeSegmentedControl: UISegmentedControl!

    override func awakeFromNib() {
        super.awakeFromNib()

        themeLabel.text = "Theme".localized
        themeSegmentedControl.selectedSegmentIndex = Theme.current.rawValue
    }

    @IBAction func themeChanged(_ sender: UISegmentedControl) {
        if let selectedTheme = Theme(rawValue: sender.selectedSegmentIndex) {
            selectedTheme.apply()
        }
    }
}
