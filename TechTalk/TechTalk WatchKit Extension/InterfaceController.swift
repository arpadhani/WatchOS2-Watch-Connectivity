//
//  InterfaceController.swift
//  TechTalk WatchKit Extension
//
//  Created by Raza Padhani on 8/25/16.
//  Copyright © 2016 Raza Padhani. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var watchLabel: WKInterfaceLabel!
    @IBOutlet var watchImage: WKInterfaceImage!
    let session = WCSession.defaultSession()
    var text = ""
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
        print("\(context)")
        if !(context == nil) {
            self.displayContext((context as? [String:String])!)
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        self.setupWatchConnectivity()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func sessionReachabilityDidChange(session: WCSession) {
        if self.session.reachable {
            self.setupWatchConnectivity()
        }
    }
    
    func setupWatchConnectivity() {
        self.session.delegate = self
        self.session.activateSession()
    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        dispatch_async(dispatch_get_main_queue()) {
            let contextValue = applicationContext["sending"] as! String
            self.watchLabel.setText("\(contextValue)")
            self.text = ""
        }
    }
    
    func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
        dispatch_async(dispatch_get_main_queue()) {
            self.text = "\(self.text) \(userInfo["sending"] as! String)\n"
            self.watchLabel.setText(self.text)
        }
    }
    
    func session(session: WCSession, didReceiveFile file: WCSessionFile) {
        //save in a more permanent location here. file will be deleted after this method is executed
        dispatch_async(dispatch_get_main_queue()) {
            let data = NSData.init(contentsOfURL: file.fileURL)
            let dict = file.metadata
            let name = dict!["sending"]
            self.watchLabel.setText(name as? String)
            self.watchImage.setImage(UIImage.init(data: data!))
            self.text = ""
        }
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        dispatch_async(dispatch_get_main_queue()) {
            self.displayContext(message)
        }
    }
    
    func displayContext(context:[String:AnyObject]) {
        dispatch_async(dispatch_get_main_queue()) {
            self.watchLabel.setText(context["sending"] as? String)
        }
    }

    @IBAction func watchSendButtonTapped() {
        self.watchLabel.setText("sending")
        self.watchImage.setImage(nil)
        self.session.sendMessage(["sending" : "Hello from Watch"], replyHandler: nil, errorHandler: nil)
        
    }
}
