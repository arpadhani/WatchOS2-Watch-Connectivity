//
//  ViewController.swift
//  TechTalk
//
//  Created by Raza Padhani on 8/25/16.
//  Copyright © 2016 Raza Padhani. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {
    
    @IBOutlet weak var textView: UITextView!
    
    let sampleContext = ["AppContext 0", "AppContext 1", "AppContext 2", "AppContext 3", "AppContext 4", "AppContext 5"]
    let userInfo = ["userInfo 0", "userInfo 1", "userInfo 2", "userInfo 3", "userInfo 4", "userInfo 5"]
    let messages = ["message 0", "message 1", "message 2", "message 3", "message 4", "message 5"]
    var count = 0
    let session = WCSession.defaultSession()
    var text = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.session.delegate = self
        self.session.activateSession()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let value = UIInterfaceOrientation.LandscapeLeft.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        //
    }
    
    func sendApplicationdata() {
        do{
            let context = ["sending":sampleContext[self.count]]
            self.text = "\(self.text) sending: \(sampleContext[self.count]) \n"
            self.textView.text = self.text
            try self.session.updateApplicationContext(context)
            self.count = self.count + 1
            if self.count == 5 {
                self.count = 0
            }
        }catch{
            //handle errors
        }
    }
    
    func sendUserInfo() {
        let context = ["sending":userInfo[self.count]]
        self.session.transferUserInfo(context)
        self.text = "\(self.text) transfer \(userInfo[self.count]) \n"
        self.textView.text = self.text
        if self.count == 5 {
            count = 0
        }
        self.count = self.count + 1
    }
    
    func sendMessage() {
        let context = ["sending":messages[self.count]]
        self.text = "\(self.text) attempting to send \(messages[self.count]) \n"
        self.textView.text = self.text
        if session.reachable {
            self.text = "\(self.text) sent \(messages[self.count]) \n"
            self.textView.text = self.text
            self.session.sendMessage(context, replyHandler: nil, errorHandler: nil)
        }
        if self.count == 5 {
            count = 0
        }
        self.count = self.count + 1
    }
    
    @IBAction func onAppContextTouched(sender: AnyObject) {
        self.sendApplicationdata()
    }
    
    @IBAction func onUserInfoTouched(sender: AnyObject) {
        self.sendUserInfo()
    }
    
    @IBAction func onFileTransferTouched(sender: AnyObject) {
        self.text = "\(self.text) Request to send file \n"
        self.textView.text = self.text
        let urlpath = NSBundle.mainBundle().pathForResource("grio-logo-square", ofType: "png")
        let url:NSURL = NSURL.fileURLWithPath(urlpath!)
        let metaData = ["sending":"Grio"]
        self.session.transferFile(url, metadata: metaData)
    }

    @IBAction func onSendMessageTouched(sender: AnyObject) {
        self.sendMessage()
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        dispatch_async(dispatch_get_main_queue()) {
            self.text = "\(self.text) \(message["sending"] as! String) \n"
            self.textView.text = self.text
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}