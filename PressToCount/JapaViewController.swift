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

    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var rowsCount: UILabel!
    @IBOutlet weak var progressBar: MBCircularProgressBarView!
    var volumeView: MPVolumeView!
    var newRowAdded: Bool = false
    var counter = Counter()
    var volumeSlider: UISlider?
    var volume: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        volumeView = MPVolumeView(frame: CGRectMake(-CGFloat.max, 0.0, 0.0, 0.0))
        volumeView.showsRouteButton = false
        volumeView.hidden = false
        view.addSubview(volumeView)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(applicationBecameActive),
                                                         name: UIApplicationDidBecomeActiveNotification,
                                                         object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(applicationBecameInactive),
                                                         name: UIApplicationWillResignActiveNotification,
                                                         object: nil)
        volume = AVAudioSession.sharedInstance().outputVolume
        volumeSlider = (volumeView.subviews.filter{NSStringFromClass($0.classForCoder) == "MPVolumeSlider"}.first as? UISlider)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        counter = Counter.getSavedCounter()
        progressBar.maxValue = CGFloat(counter.maxClickCount)
        progressBar.setValue(CGFloat(counter.currentClickCount), animateWithDuration: 0.2)
        rowsCount.text = "\(counter.currentRowsCount)"
//
//        
//        //TODO: need to finish
//        let inputType = (NSUserDefaults.standardUserDefaults().objectForKey(userInputType) as! NSString).integerValue
//        switch inputType {
//        case InputTypeEnum.volume.rawValue:
//            tapRecognizer.enabled = false
//        case InputTypeEnum.tap.rawValue:
//            tapRecognizer.enabled = true
//        case InputTypeEnum.both.rawValue:
//            tapRecognizer.enabled = true
//        default:
//            tapRecognizer.enabled = true
//        }
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
        //reset volume
        volume = AVAudioSession.sharedInstance().outputVolume
        //need for dissapear Volume HUD
        do {
            //listen to hardware volume buttons
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ {}
    }
    
    func applicationBecameInactive() {
        counter.save(Int(progressBar.value), curRowsCount: Int(rowsCount.text!))
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "AVSystemController_SystemVolumeDidChangeNotification", object: nil)
        if let vSlider = volumeSlider {
            vSlider.setValue(volume, animated: false)
        }
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
        counter.save(Int(progressBar.value), curRowsCount: Int(rowsCount.text!))
    }
    
    func mantraPlus() {
        if(newRowAdded) {
            progressBar.setValue(CGFloat(0), animateWithDuration: 0.5)
            newRowAdded = false
        }
        
        let value = Int(progressBar.value) + 1
        progressBar.setValue(CGFloat(value), animateWithDuration: 0.25)
        
        if counter.maxClickCount == Int(value) {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            rowsCount.text = String(Int(rowsCount.text!)! + 1)
            newRowAdded = true
        }
    }
}

