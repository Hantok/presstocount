//
//  RageProducts.swift
//  PressToCount
//
//  Created by Roman Slysh on 11/14/16.
//  Copyright © 2016 Roman Slysh. All rights reserved.
//

import Foundation

public struct Products {
    
    public static let RemoveAds = "rslysh.Clicker.RemoveAdsTest"
    
    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [Products.RemoveAds]
    
    public static let store = IAPHelper(productIds: Products.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
