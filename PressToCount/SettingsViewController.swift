//
//  SettingsViewController.swift
//  PressToCount
//
//  Created by Roman Slysh on 5/10/16.
//  Copyright © 2016 Roman Slysh. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: AnyObject) {
        let counter = Counter.getSavedCounter()
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! MantraCountTableViewCell
        if counter.currentClickCount > Int(cell.stepper.value) {
            counter.save(Int(cell.stepper.value)-1, maximumClickCount: Int(cell.stepper.value))
        } else {
            counter.save(maximumClickCount: Int(cell.stepper.value))
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: TableView delegate/datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let counter = Counter.getSavedCounter()
        switch (indexPath as NSIndexPath).row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MantraCell", for: indexPath) as! MantraCountTableViewCell
            cell.stepper.value = Double(counter.maxClickCount)
            cell.stepperLabel?.text = "Repeat's count: ".localized + "\(counter.maxClickCount)"
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InputType", for: indexPath) as! InputTypeTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.inputTypePickerView.subviews[1].backgroundColor = UIColor.white
            cell.inputTypePickerView.subviews[2].backgroundColor = UIColor.white
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MantraCell", for: indexPath) as! MantraCountTableViewCell
            cell.stepper.value = Double(counter.maxClickCount)
            cell.stepperLabel?.text = "Repeat's count: ".localized + "\(counter.maxClickCount)"
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).row == 1 {
            return 138
        }
        return 40
    }
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
