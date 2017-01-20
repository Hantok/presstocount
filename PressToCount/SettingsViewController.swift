//
//  SettingsViewController.swift
//  PressToCount
//
//  Created by Roman Slysh on 5/10/16.
//  Copyright © 2016 Roman Slysh. All rights reserved.
//

import UIKit
import Appodeal
import StoreKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let kSectionsNumber = 1
    var rowsNumber = 3

    @IBOutlet weak var tableView: UITableView!
    
    var product = SKProduct()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.init(colorLiteralRed: 51/255, green: 149/255, blue: 211/255, alpha: 1)
        
        let restoreButton = UIBarButtonItem(title: "Restore".localized,
                                            style: .plain,
                                            target: self,
                                            action: #selector(SettingsViewController.restoreTapped(_:)))

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(SettingsViewController.handlePurchaseNotification(_:)),
                                               name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification),
                                               object: nil)
        
        Appodeal.showAd(AppodealShowStyle.bannerBottom, rootViewController: self)
        //Appodeal.setBannerDelegate(self)
        //Appodeal.setTestingEnabled(true)
        //APDSdk.shared().setLogLevel(APDLogLevel.debug)
        Appodeal.setBannerBackgroundVisible(true)
        Appodeal.setSmartBannersEnabled(true)
        
        Products.store.requestProducts{success, products in
            if success {
                if let prdcts = products {
                    let product = prdcts[0]
                    if !Products.store.isProductPurchased(product.productIdentifier) {
                        self.product = product
                        self.rowsNumber = 4
                        self.tableView.reloadData()
                        self.navigationItem.rightBarButtonItem = restoreButton
                    } else {
                        self.navigationItem.rightBarButtonItem = nil
                        //removeAds
                    }
                }
            }
        }
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
        return kSectionsNumber
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsNumber
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
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShowTutorial", for: indexPath)
            cell.textLabel?.text = "Show tutorial".localized
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RemoveAds", for: indexPath)  as! ProductCell
            cell.textLabel?.text = "Remove ads".localized
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.product = product
            cell.buyButtonHandler = { product in
                Products.store.buyProduct(product)
            }

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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            performSegue(withIdentifier: "ShowTutorial", sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        if indexPath.row == 3 {
            
        }
    }
        
    func restoreTapped(_ sender: AnyObject) {
        Products.store.restorePurchases()
    }
    
    func handlePurchaseNotification(_ notification: Notification) {
        guard let productID = notification.object as? String else { return }
        if product.productIdentifier == productID {
            self.navigationItem.rightBarButtonItem = nil
            self.rowsNumber = 3
            tableView.deleteRows(at:  [IndexPath(row: 3, section: 0)], with: .fade)
            //removeAds
        }
    }
}
