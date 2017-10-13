//
//  ProductCell.swift
//  PressToCount
//
//  Created by Roman Slysh on 11/14/16.
//  Copyright © 2016 Roman Slysh. All rights reserved.
//

import UIKit
import StoreKit

class ProductCell: UITableViewCell {
    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()

        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency

        return formatter
    }()

    var buyButtonHandler: ((_ product: SKProduct) -> Void)?

    var product: SKProduct? {
        didSet {
            guard let product = product else { return }

            textLabel?.text = product.localizedTitle
            selectionStyle = .none

            if Products.store.isProductPurchased(product.productIdentifier) {
                accessoryType = .checkmark
                accessoryView = nil
                detailTextLabel?.text = ""
            } else {
                textLabel?.text = "Remove ads".localized
                ProductCell.priceFormatter.locale = product.priceLocale
                detailTextLabel?.text = ProductCell.priceFormatter.string(from: product.price)
                accessoryType = .none
                accessoryView = newBuyButton()
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        textLabel?.text = ""
        detailTextLabel?.text = ""
        accessoryView = nil
    }

    func newBuyButton() -> UIButton {
        let button = UIButton(type: .system)
        //button.setTitleColor(.clickerBlue, for: .normal)
        button.setTitle("Buy".localized, for: UIControlState())
        button.addTarget(self, action: #selector(ProductCell.buyButtonTapped(_:)), for: .touchUpInside)
        button.sizeToFit()

        return button
    }

    func buyButtonTapped(_ sender: AnyObject) {
        guard let prod = product else {
            return
        }
        buyButtonHandler?(prod)
    }
}
