//
//  JapaViewController.swift
//  Sadhana
//
//  Created by Roman Slysh on 5/9/16.
//  Copyright © 2016 Roman Slysh. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class JapaViewController: UIViewController {

    @IBOutlet weak var mantraCount: UILabel!
    @IBOutlet weak var rowsCount: UILabel!
    var volumeView: MPVolumeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        volumeView = MPVolumeView(frame: CGRectMake(-CGFloat.max, 0.0, 0.0, 0.0))
        volumeView.showsRouteButton = false;
        volumeView.hidden = false;
        self.view.addSubview(volumeView);
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(applicationBecameActive),
                                                         name: UIApplicationDidBecomeActiveNotification,
                                                         object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(applicationBecameInactive),
                                                         name: UIApplicationWillResignActiveNotification,
                                                         object: nil)
    }

    func volumeChanged(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            if let volumeChangeType = userInfo["AVSystemController_AudioVolumeChangeReasonNotificationParameter"] as? String {
                if volumeChangeType == "ExplicitVolumeChange" {
                    if Int(mantraCount.text!)! == NSUserDefaults.standardUserDefaults().objectForKey(standartMantraCount)?.integerValue {
                        mantraCount.text = "0"
                        rowsCount.text = String(Int(rowsCount.text!)! + 1)
                        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                        return
                    }
                    mantraCount.text = String(Int(mantraCount.text!)! + 1)
                }
            }
        }
    }
    
    func applicationBecameActive() {
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(volumeChanged(_:)),
                                                         name: "AVSystemController_SystemVolumeDidChangeNotification",
                                                         object: nil)
        //need for dissapear Volume HUD
        do {
            //listen to hardware volume buttons
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ {}
    }
    
    func applicationBecameInactive() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "AVSystemController_SystemVolumeDidChangeNotification", object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func reset(sender: AnyObject) {
        //TODO: add UIAlertController and allow user to choose what to reset
        mantraCount.text = "0";
        rowsCount.text = "0";
    }

    @IBAction func changeSettings(sender: AnyObject) {
    }
}

