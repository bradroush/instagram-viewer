//
//  InstagramAPIClient.swift
//  InstagramViewer
//
//  Created by Brad Roush on 4/24/16.
//  Copyright © 2016 Brad Roush. All rights reserved.
//

import UIKit

// Client Application Constants
let InstagramClientID = "46e41587631143a3adc9031f93d515fb"
let InstagramRedirectURI = "myfeed://authenticate"

// Notification Namse
let NotificationAccessTokenSaved = "NotificationAccessTokenSaved"

// Closure used for completing media requests
typealias MediaCompletionClosure = (media: [MediaData]?, error: InstagramAPIClientError?) -> Void

// Possible errors for during API calls
enum InstagramAPIClientError {
    case MissingAccessToken, Network, AccessTokenError, JsonSerialization, JsonParsing, Other
}

class InstagramAPIClient: NSObject {
    
    // Singleton implementation
    static let sharedClient = InstagramAPIClient()
    
    // URL Constants
    let apiRootURL = "https://api.instagram.com"
    let apiVersion = "v1"
    
    // Other Constants
    let keychain = Keychain()
    let accessTokenStorageKey = "com.bradroush.instagramviewer.instagramapiclient.accesstoken"
    
    /*
     This client is going to use "Client-Side (Implicit) Authentication" as shown here:
     https://www.instagram.com/developer/authentication/
     */
    func authorize() {
        let apiEndPoint = "/oauth/authorize/"
        let url = NSURL(string: "\(apiRootURL)\(apiEndPoint)?client_id=\(InstagramClientID)&redirect_uri=\(InstagramRedirectURI)&response_type=token")
        UIApplication.sharedApplication().openURL(url!)
    }
    
    func setAccessToken(accessToken: String) {
        // When dealing with sensitive information like an access token it is important that it is stored securely
        keychain[accessTokenStorageKey] = accessToken
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationAccessTokenSaved, object: nil)
    }
    
    func getCurrentUserRecentMedia(count: Int, completion: MediaCompletionClosure) {
        let apiEndPoint = "/users/self/media/recent/"
        
        guard let accessToken = keychain[accessTokenStorageKey] else {
            completion(media: nil, error: .MissingAccessToken)
            return
        }
        
        let url = NSURL(string: "\(apiRootURL)/\(apiVersion)\(apiEndPoint)?access_token=\(accessToken)&count=\(count)")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!) { (possibleData, response, error) in
            
            // Check for network error
            if let error = error {
                print("NSURL Session Error: \(error)")
                completion(media: nil, error: .Network)
                return
            }
            
            // Validate there is data available
            guard let data = possibleData else {
                completion(media: nil, error: .Other)
                return
            }
            
            // Serialize JSON
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                if let jsonDictionary = json as? [String:AnyObject] {
                    MediaParser().processRecentMedia(jsonDictionary, completion: completion)
                } else {
                    completion(media: nil, error: .JsonParsing)
                }
            } catch {
                completion(media: nil, error: .JsonSerialization)
            }
        }
        task.resume()
    }

}