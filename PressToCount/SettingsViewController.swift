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
    //TODO: - need for App Store submit
    var numberOfRows = 1 // 2
    var dummyInt = 0

    @IBOutlet weak var tableView: UITableView!
    var restoreButton: UIBarButtonItem?

    var product = SKProduct()

    override func viewDidLoad() {
        super.viewDidLoad()

        restoreButton = UIBarButtonItem(title: "Restore".localized,
                                            style: .plain,
                                            target: self,
                                            action: #selector(SettingsViewController.restoreTapped(_:)))

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()

        NotificationCenter.default.addObserver(self, selector: #selector(handlePurchaseNotification(_:)),
                                               name: .IAPHelperPurchaseNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleRestoreError(_:)),
                                               name: .IAPHelperRestoreFailed,
                                               object: nil)

        showHideButtomBanner(viewController: self)

        requestIAPProducts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        back()
    }

    func back() {
        defer {
            self.dismiss(animated: true, completion: nil)
        }
        let counter = Counter.getSavedCounter()

        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MantraCountTableViewCell else {
            return
        }
        if counter.currentClickCount > Int(cell.stepper.value) {
            counter.save(Int(cell.stepper.value)-1, maximumClickCount: Int(cell.stepper.value))
        } else {
            counter.save(maximumClickCount: Int(cell.stepper.value))
        }
    }

    private func requestIAPProducts() {
        Products.store.requestProducts {success, products in
            if success {
                if let prdcts = products, let product = prdcts.first {
                    if !Products.store.isProductPurchased(product.productIdentifier) {
                        self.product = product
                        //TODO: - need for App Store submit
                        self.numberOfRows = 2 //3
                        self.tableView.reloadData()
                        self.navigationItem.rightBarButtonItem = self.restoreButton
                    } else {
                        self.navigationItem.rightBarButtonItem = nil
                    }
                }
            } else {
                if self.dummyInt < 5 {
                    self.dummyInt = self.dummyInt + 1
                    self.requestIAPProducts()
                }
            }
        }
    }

    // MARK: TableView delegate/datasource

    func numberOfSections(in tableView: UITableView) -> Int {
        return kSectionsNumber
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let counter = Counter.getSavedCounter()
        switch (indexPath as NSIndexPath).row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MantraCell", for: indexPath) as? MantraCountTableViewCell else {
                return MantraCountTableViewCell()
            }
            cell.stepper.value = Double(counter.maxClickCount)
            cell.stepperLabel?.text = "Repeat's count: ".localized + "\(counter.maxClickCount)"
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
            //TODO: - need for App Store submit
        case 1:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "InputType", for: indexPath) as! InputTypeTableViewCell
//            cell.selectionStyle = UITableViewCellSelectionStyle.none
//            cell.inputTypePickerView.subviews[1].backgroundColor = UIColor.white
//            cell.inputTypePickerView.subviews[2].backgroundColor = UIColor.white
//            return cell
//        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RemoveAds", for: indexPath) as? ProductCell else {
                return ProductCell()
            }
            cell.product = product
            cell.buyButtonHandler = { product in
                Products.store.buyProduct(product)
            }

            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MantraCell", for: indexPath) as? MantraCountTableViewCell else {
                return MantraCountTableViewCell()
            }
            cell.stepper.value = Double(counter.maxClickCount)
            cell.stepperLabel?.text = "Repeat's count: ".localized + "\(counter.maxClickCount)"
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //TODO: - need for App Store submit
//        if (indexPath as NSIndexPath).row == 1 {
//            return 138
//        }
        return 50
    }

    func restoreTapped(_ sender: AnyObject) {
        Products.store.restorePurchases()
    }

    func handlePurchaseNotification(_ notification: Notification) {
        guard let productID = notification.object as? String else { return }
        if product.productIdentifier == productID {
            self.navigationItem.rightBarButtonItem = nil
            self.numberOfRows = 1
            tableView.deleteRows(at:  [IndexPath(row: 1, section: 0)], with: .fade)
            showHideButtomBanner(viewController: self)
            showAlert(message: "Purchase restored successfully!".localized)
        }
    }

    func handleRestoreError(_ notification: Notification) {
        showAlert(message: "Previous purchase not found!".localized)
    }

    func showAlert(title: String? = nil, message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        //alert.view.tintColor = .clickerBlue

        let okAction = UIAlertAction(title: "OK".localized, style: .default, handler: nil)

        alert.addAction(okAction)

        if let presentView = UIApplication.shared.keyWindow?.rootViewController?.view {
            alert.popoverPresentationController?.sourceView = presentView
            alert.popoverPresentationController?.sourceRect = CGRect(x: presentView.bounds.midX, y: presentView.bounds.midY, width: 0, height: 0)
            alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }

        alert.present()
    }
}
