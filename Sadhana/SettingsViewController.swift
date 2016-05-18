//
//  SettingsViewController.swift
//  Sadhana
//
//  Created by Roman Slysh on 5/10/16.
//  Copyright © 2016 Roman Slysh. All rights reserved.
//

import UIKit

let userMantraCount = "userMantraCount"
let currentMantraCount = "currentMantraCount"
let currentRowsCount = "currentRowsCount"
let userInputType = "userInputType"

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
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: TableView delegate/datasource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("MantraCell", forIndexPath: indexPath) as! MantraCountTableViewCell
            cell.stepper.value = Double(String(NSUserDefaults.standardUserDefaults().objectForKey(userMantraCount)!))!
            cell.stepperLabel?.text = "Beads count: \(Int(cell.stepper.value))"
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("InputType", forIndexPath: indexPath) as! MantraCountTableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("MantraCell", forIndexPath: indexPath) as! MantraCountTableViewCell
            cell.stepper.value = Double(String(NSUserDefaults.standardUserDefaults().objectForKey(userMantraCount)!))!
            cell.stepperLabel?.text = "Beads count: \(Int(cell.stepper.value))"
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
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
