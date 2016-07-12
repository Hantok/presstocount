//
//  InputTypeTableViewCell.swift
//  Sadhana
//
//  Created by Roman Slysh on 5/13/16.
//  Copyright © 2016 Roman Slysh. All rights reserved.
//

import UIKit

let pickerHeightMinimized: CGFloat = 50
let pickerHeightMaximized: CGFloat = 216//may be took from the picker view itself

class InputTypeTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate, HitTestDelegate {

    @IBOutlet weak var inputTypePickerView: HitTestPickerView!
    @IBOutlet weak var inputTypePickerSuperviewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var inputTypePickerSuperviewTopConstraint    : NSLayoutConstraint!
    
    var animationsEnabled = false
    var lastAnimatedView: UIView?
    var minimizationTimer: NSTimer?
    
    var counter = Counter.getSavedCounter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        inputTypePickerView.delegate = self
        inputTypePickerView.dataSource = self
        inputTypePickerView.hitTestDelegate = self
        
        inputTypePickerView.selectRow(counter.inputType.rawValue, inComponent: 0, animated: true)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - UIPickerView
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch row {
        case InputTypeEnum.volume.rawValue:
            return "Volume buttons".localized
        case InputTypeEnum.tap.rawValue:
            return "Screen touch".localized
        case InputTypeEnum.both.rawValue:
            return "All".localized
        default:
            return String(InputTypeEnum.both)
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case InputTypeEnum.volume.rawValue:
            counter.save(inputTypeEnum: InputTypeEnum.volume)
        case InputTypeEnum.tap.rawValue:
            counter.save(inputTypeEnum: InputTypeEnum.tap)
        case InputTypeEnum.both.rawValue:
            counter.save(inputTypeEnum: InputTypeEnum.both)
        default:
            counter.save(inputTypeEnum: InputTypeEnum.both)
        }
    }
    
    func minimizeViewAnimatedIfNeeded() {
        if let lastAnimated = lastAnimatedView {
            minimizeViewAnimated(lastAnimated)
            lastAnimatedView = nil
        }
    }
    
    func hitTestCalledForView(view: UIView){
        self.endEditing(true)
        if let lastAnimated = lastAnimatedView {
            minimizeViewAnimated(lastAnimated)
        }
        lastAnimatedView = view
        maximizeView(view)
        minimizationTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(InputTypeTableViewCell.minimizeViewAnimatedIfNeeded), userInfo: nil, repeats: false)
    }
    
    func maximizeView(view: UIView) {
        inputTypePickerSuperviewTopConstraint.constant -= (pickerHeightMaximized - pickerHeightMinimized)/2
        inputTypePickerSuperviewHeightConstraint.constant = pickerHeightMaximized
        inputTypePickerView.layoutIfNeeded()
    }
    
    func maximizeViewAnimated(view: UIView){
        UIView.animateWithDuration(0.5, delay: 0, options: [.AllowUserInteraction], animations: {self.maximizeView(view)}, completion: nil)
    }
    
    func minimizeView(view: UIView) {
        inputTypePickerSuperviewTopConstraint.constant += (pickerHeightMaximized - pickerHeightMinimized)/2
        inputTypePickerSuperviewHeightConstraint.constant = pickerHeightMinimized
    }
    
    func minimizeViewAnimated(view: UIView){
        UIView.animateWithDuration(0.3) {
            self.minimizeView(view)
        }
    }
    
    deinit {
        minimizationTimer?.invalidate()
    }

}
