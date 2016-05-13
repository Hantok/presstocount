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
import MBCircularProgressBar

class JapaViewController: UIViewController {

    @IBOutlet weak var rowsCount: UILabel!
    @IBOutlet weak var progressBar: MBCircularProgressBarView!
    var volumeView: MPVolumeView!
    var newRowAdded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        volumeView = MPVolumeView(frame: CGRectMake(-CGFloat.max, 0.0, 0.0, 0.0))
        volumeView.showsRouteButton = false;
        volumeView.hidden = false;
        self.view.addSubview(volumeView);
        
        let curMantraCount = NSUserDefaults.standardUserDefaults().objectForKey(currentMantraCount)?.integerValue
        progressBar.setValue(curMantraCount != nil ? CGFloat(curMantraCount!) : 0, animateWithDuration: 0.2)
        
        if (NSUserDefaults.standardUserDefaults().objectForKey(currentRowsCount) != nil) {
            rowsCount.text = String(NSUserDefaults.standardUserDefaults().objectForKey(currentRowsCount)!)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(applicationBecameActive),
                                                         name: UIApplicationDidBecomeActiveNotification,
                                                         object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(applicationBecameInactive),
                                                         name: UIApplicationWillResignActiveNotification,
                                                         object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        progressBar.maxValue = CGFloat(NSUserDefaults.standardUserDefaults().objectForKey(standartMantraCount)!.integerValue)
    }

    func volumeChanged(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            if let volumeChangeType = userInfo["AVSystemController_AudioVolumeChangeReasonNotificationParameter"] as? String {
                if volumeChangeType == "ExplicitVolumeChange" {
                    mantraPlus();
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
        NSUserDefaults.standardUserDefaults().setObject(progressBar.value, forKey: currentMantraCount)
        NSUserDefaults.standardUserDefaults().setObject(rowsCount.text, forKey: currentRowsCount)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "AVSystemController_SystemVolumeDidChangeNotification", object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func reset(sender: AnyObject) {
        //TODO: add UIAlertController and allow user to choose what to reset
        progressBar.setValue(CGFloat(0), animateWithDuration: 0.5)
        rowsCount.text = "0"
    }
    @IBAction func tapOnScreen(sender: AnyObject) {
        mantraPlus();
    }

    @IBAction func changeSettings(sender: AnyObject) {
    }
    
    func mantraPlus() {
        if(newRowAdded) {
            progressBar.setValue(CGFloat(0), animateWithDuration: 0.5)
            newRowAdded = false
        }
        
        let value = Int(progressBar.value) + 1
        progressBar.setValue(CGFloat(value), animateWithDuration: 0.25)
        
        if Int(value) == NSUserDefaults.standardUserDefaults().objectForKey(standartMantraCount)?.integerValue {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            rowsCount.text = String(Int(rowsCount.text!)! + 1)
            newRowAdded = true
        }
    }
}

