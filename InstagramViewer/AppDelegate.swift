//
//  AppDelegate.swift
//  InstagramViewer
//
//  Created by Brad Roush on 4/24/16.
//  Copyright © 2016 Brad Roush. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        let urlString = url.absoluteString
        
        // Instagram authentication redirect API
        if urlString.hasPrefix(InstagramRedirectURI) {
            if let accessToken = AccessTokenParser.parse(urlString) {
                InstagramAPIClient.sharedClient.setAccessToken(accessToken)
            }
        }
        return true
    }
    
}

