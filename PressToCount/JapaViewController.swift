//
//  JapaViewController.swift
//  PressToCount
//
//  Created by Roman Slysh on 5/9/16.
//  Copyright © 2016 Roman Slysh. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import MBCircularProgressBar
import Appodeal

class JapaViewController: UIViewController {

    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var rowsCount: UILabel!
    @IBOutlet weak var progressBar: MBCircularProgressBarView!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    var volumeView: MPVolumeView!
    var newRowAdded: Bool = false
    var counter = Counter.getSavedCounter()
    var volumeSlider: UISlider?
    var volume: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsButton.image = UIImage(named: "settings")?.scaledTo(size: CGSize(width: 30, height: 30))

        //TODO: - need for App Store submit
        //counter.save(inputTypeEnum: .tap)
        
        volumeView = MPVolumeView(frame: CGRect(x: -CGFloat.greatestFiniteMagnitude, y: 0.0, width: 0.0, height: 0.0))
        volumeView.showsRouteButton = false
        volumeView.isHidden = false
        view.addSubview(volumeView)
        
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(applicationBecameActive),
                                                         name: NSNotification.Name.UIApplicationDidBecomeActive,
                                                         object: nil)
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(applicationBecameInactive),
                                                         name: NSNotification.Name.UIApplicationWillResignActive,
                                                         object: nil)
        volume = AVAudioSession.sharedInstance().outputVolume
        volumeSlider = (volumeView.subviews.filter{NSStringFromClass($0.classForCoder) == "MPVolumeSlider"}.first as? UISlider)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        counter = Counter.getSavedCounter()
        progressBar.maxValue = CGFloat(counter.maxClickCount)
        if (counter.maxClickCount == counter.currentClickCount) {
            progressBar.setValue(0, animateWithDuration: 0.2)
        } else {
            progressBar.setValue(CGFloat(counter.currentClickCount), animateWithDuration: 0.2)
        }
        rowsCount.text = "\(counter.currentRowsCount)"

        activateNeededInputType()
        
//        if !UserDefaults.standard.bool(forKey: FirstRun) {
//            UserDefaults.standard.setValue(true, forKey: FirstRun)
//            UserDefaults.standard.synchronize()
//            performSegue(withIdentifier: FirstRun, sender: self)
//        }

        showHideButtomBanner(viewController: self)
    }

    func volumeChanged(_ notification: Notification) {
        if let userInfo = (notification as NSNotification).userInfo {
            if let volumeChangeType = userInfo["AVSystemController_AudioVolumeChangeReasonNotificationParameter"] as? String {
                if volumeChangeType == "ExplicitVolumeChange" {
                    mantraPlus();
                }
            }
        }
    }
    
    func applicationBecameActive() {
        activateNeededInputType()
    }
    
    func applicationBecameInactive() {
        counter.save(Int(progressBar.value), curRowsCount: Int(rowsCount.text!))
        deactivateVolumeButtons()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func reset(_ sender: AnyObject) {
        let resetAllAction = UIAlertAction(title: "Reset all".localized, style: .default) { (_) in
            self.progressBar.setValue(CGFloat(0), animateWithDuration: 0.5)
            self.rowsCount.text = "0"
        }
        let resetCountAction = UIAlertAction(title: "Reset counter".localized, style: .default) { (_) in
            self.progressBar.setValue(CGFloat(0), animateWithDuration: 0.5)
        }
        let resetRowsAction = UIAlertAction(title: "Reset repeat's count".localized, style: .default) { (_) in
            self.rowsCount.text = "0"
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel) { (_) in }
        
        let alertController = UIAlertController(title: "Reset what you need :)".localized, message: nil, preferredStyle: .alert)
        alertController.addAction(resetAllAction)
        alertController.addAction(resetCountAction)
        alertController.addAction(resetRowsAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true) {}
    }
    @IBAction func tapOnScreen(_ sender: AnyObject) {
        mantraPlus();
    }
    
    @IBAction func changeSettings(_ sender: Any) {
        counter.save(Int(progressBar.value), curRowsCount: Int(rowsCount.text!))
        performSegue(withIdentifier: "showSettings", sender: nil)
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
    
    @IBAction func share(_ sender: AnyObject) {
        let textToShare = "Replace your clicker with the app:".localized
        
        if let myWebsite = NSURL(string: "http://apple.co/2m5rZSD") {
            let objectsToShare = ["\(textToShare) \(myWebsite)"]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            
            activityVC.popoverPresentationController?.sourceView = sender as? UIView
            self.present(activityVC, animated: true, completion: nil)
        }
        
    }
    func activateNeededInputType() {
        
        //TODO: need to finish
        switch counter.inputType {
        case InputTypeEnum.volume:
            deactivateVolumeButtons()
            activateVolumeButtons()
            tapRecognizer.isEnabled = false
        case InputTypeEnum.tap:
            tapRecognizer.isEnabled = true
            deactivateVolumeButtons()
        case InputTypeEnum.both:
            tapRecognizer.isEnabled = true
            deactivateVolumeButtons()
            activateVolumeButtons()
        }
    }
    
    func activateVolumeButtons() {
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(volumeChanged(_:)),
                                                         name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"),
                                                         object: nil)
        //reset volume
        volume = AVAudioSession.sharedInstance().outputVolume
        //need for dissapear Volume HUD
        do {
            //listen to hardware volume buttons
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ {}
    }
    
    func deactivateVolumeButtons() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
        if let vSlider = volumeSlider {
            vSlider.setValue(volume, animated: false)
        }
    }
    
    //MARK: - AppodealBannerDelegate
    
    func bannerDidLoadAdIsPrecache(_ precache: Bool){
        
    }
    func bannerDidLoadAd(){
        
    }
    func bannerDidRefresh(){
        
    }
    func bannerDidFailToLoadAd(){
        
    }
    func bannerDidClick(){
        
    }
    func bannerDidShow(){
        
    }
}

