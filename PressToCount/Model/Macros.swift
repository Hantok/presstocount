//
//  Macros.swift
//  PressToCount
//
//  Created by Roman Slysh on 2/3/17.
//  Copyright © 2017 Roman Slysh. All rights reserved.
//

import UIKit
import Appodeal

let firstRun = "firstRun"

extension Notification.Name {
    static let IAPHelperPurchaseNotification = Notification.Name("IAPHelperPurchaseNotification")
    static let IAPHelperRestoreFailed = Notification.Name("IAPHelperRestoreFailed")
}

extension UIAlertController {
    /// Present the alert on the root view controller
    func present() {
        UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: true, completion: nil)
    }
}

extension UIColor {
    static var clickerBlue: UIColor {
        return UIColor.init(colorLiteralRed: 51/255, green: 149/255, blue: 211/255, alpha: 1)
    }
}

extension UIViewController: AppodealBannerDelegate {
    func showHideButtomBanner(viewController: UIViewController) {
        if !UserDefaults.standard.bool(forKey: Products.RemoveAds) {
            Appodeal.showAd(AppodealShowStyle.bannerBottom, rootViewController: viewController)
            Appodeal.setBannerDelegate(viewController)
            Appodeal.setBannerBackgroundVisible(true)
            Appodeal.setSmartBannersEnabled(true)
        } else {
            if Appodeal.isInitalized() {
                Appodeal.hideBanner()
            }
        }
    }
}

extension UIImage {

    func scaledTo(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: size.width, height: size.height)))
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return self }
        UIGraphicsEndImageContext()
        return newImage
    }
}
