//
//  Theme.swift
//  PressToCount
//
//  Created by Roman Slysh on 3/4/18.
//  Copyright © 2018 Roman Slysh. All rights reserved.
//

import UIKit
import MBCircularProgressBar

enum Theme: Int {
    case `default`, dark

    private enum Keys {
        static let selectedTheme = "SelectedTheme"
    }

    static var current: Theme {
        let storedTheme = UserDefaults.standard.integer(forKey: Keys.selectedTheme)
        return Theme(rawValue: storedTheme) ?? .default
    }

    var mainColor: UIColor {
        switch self {
        case .default:
            return .clickerBlue
        case .dark:
            return UIColor(red: 255.0/255.0, green: 115.0/255.0, blue: 50.0/255.0, alpha: 1.0)
        }
    }

    var barStyle: UIBarStyle {
        switch self {
        case .default:
            return .default
        case .dark:
            return .black
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .default:
            return UIColor.white
        case .dark:
            return .black
        }
    }

    var textColor: UIColor {
        switch self {
        case .default:
            return UIColor.black
        case .dark:
            return .mercury
        }
    }

    func apply() {
        UserDefaults.standard.set(rawValue, forKey: Keys.selectedTheme)
        UserDefaults.standard.synchronize()

        UIApplication.shared.delegate?.window??.tintColor = mainColor

        UINavigationBar.appearance().barStyle = barStyle

        View.appearance().backgroundColor = backgroundColor
        UITableView.appearance().backgroundColor = backgroundColor

        MBCircularProgressBarView.appearance().tintColor = mainColor
        MBCircularProgressBarView.appearance().progressColor = mainColor
        MBCircularProgressBarView.appearance().progressStrokeColor = mainColor
        MBCircularProgressBarView.appearance().fontColor = textColor

        UITableViewCell.appearance().backgroundColor = backgroundColor

        UILabel.appearance().textColor = textColor

        for window in UIApplication.shared.windows {
            for view in window.subviews {
                view.removeFromSuperview()
                window.addSubview(view)
            }
            // update the status bar if you change the appearance of it.
            window.rootViewController?.setNeedsStatusBarAppearanceUpdate()
        }
    }
}
