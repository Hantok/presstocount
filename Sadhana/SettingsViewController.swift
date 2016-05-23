//
//  SettingsViewController.swift
//  Sadhana
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
    
    @IBAction func back(sender: AnyObject) {
        let counter = Counter.getSavedCounter()
        
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! MantraCountTableViewCell
        if counter.currentClickCount > Int(cell.stepper.value) {
            counter.save(Int(cell.stepper.value)-1, maximumClickCount: Int(cell.stepper.value))
        } else {
            counter.save(maximumClickCount: Int(cell.stepper.value))
        }
        
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
        let counter = Counter.getSavedCounter()
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("MantraCell", forIndexPath: indexPath) as! MantraCountTableViewCell
            cell.stepper.value = Double(counter.maxClickCount)
            cell.stepperLabel?.text = "Count of clicks: \(counter.maxClickCount)"
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("InputType", forIndexPath: indexPath) as! MantraCountTableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("MantraCell", forIndexPath: indexPath) as! MantraCountTableViewCell
            cell.stepper.value = Double(counter.maxClickCount)
            cell.stepperLabel?.text = "Count of clicks: \(counter.maxClickCount)"
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
