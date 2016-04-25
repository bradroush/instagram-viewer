//
//  LoginViewController.swift
//  InstagramViewer
//
//  Created by Brad Roush on 4/24/16.
//  Copyright © 2016 Brad Roush. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Decided to use the Notification pattern here but it can also be done with delegation
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.close), name: NotificationAccessTokenSaved, object: nil)
    }
    
    @IBAction func login(sender: AnyObject) {
        InstagramAPIClient.sharedClient.authorize()
    }
    
    func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
