//
//  AppDelegate.swift
//  PressToCount
//
//  Created by Roman Slysh on 5/9/16.
//  Copyright © 2016 Roman Slysh. All rights reserved.
//

import UIKit
import Appodeal
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if !UserDefaults.standard.bool(forKey: Products.RemoveAds) {
            let adTypes: AppodealAdType = [.banner]
            Appodeal.initialize(withApiKey:"6d1ffa97eb13afd4dc6434ef16da9448a719131f0137036e", types: adTypes)
        }
        self.window?.tintColor = .clickerBlue
        Fabric.with([Crashlytics.self])
        return true
    }
}
