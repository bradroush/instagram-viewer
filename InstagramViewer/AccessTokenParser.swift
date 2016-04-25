//
//  AccessTokenParser.swift
//  InstagramViewer
//
//  Created by Brad Roush on 4/24/16.
//  Copyright © 2016 Brad Roush. All rights reserved.
//

import UIKit

class AccessTokenParser: NSObject {
    
    // Expecting the url to look like this: myfeed://authenticate#access_token=ABC123
    class func parse(urlString: String) -> String? {
        // First get the correct url fragments
        let urlFragments = urlString.componentsSeparatedByString("#")
        if urlFragments.count < 2 {
            return nil
        }
        let accessTokenFragment = urlFragments[1]
        
        // Now get the actual token value
        let accessTokenKeyValue = accessTokenFragment.componentsSeparatedByString("=")
        if accessTokenKeyValue.count < 2 || accessTokenKeyValue[0] != "access_token" {
            return nil
        }
        return accessTokenKeyValue[1]
    }

}