//
//  MediaParser.swift
//  InstagramViewer
//
//  Created by Brad Roush on 4/24/16.
//  Copyright © 2016 Brad Roush. All rights reserved.
//

import UIKit

// Docs for parsing can be found here: https://www.instagram.com/developer/endpoints/users/

class MediaParser: NSObject {
    
    func processRecentMedia(recentMedia: [String:AnyObject], completion: MediaCompletionClosure) {
        guard let mediaArray = recentMedia["data"] as? [[String:AnyObject]] else {
            // There is no media in data key, see if the token is invalid
            if let meta = recentMedia["meta"],
                code = meta["code"] as? Int
                where code == 400
            {
                completion(media: nil, error: .AccessTokenError)
            } else {
                completion(media: nil, error: .JsonParsing)
            }
            return
        }
        
        var mediaToReturn = [MediaData]()
        var error: InstagramAPIClientError?
        for media in mediaArray {
            
            // Media ID
            guard let id = media["id"] as? String else {
                print("Media ID is not a string")
                error = .JsonParsing
                continue
            }
            
            // Thumbnail Image
            guard let
                images = media["images"] as? [String:AnyObject],
                thumbnail = images["thumbnail"] as? [String:AnyObject],
                thumbnailUrl = thumbnail["url"] as? String,
                thumbnailWidth = thumbnail["width"] as? Int,
                thumbnailHeight = thumbnail["height"] as? Int else
            {
                print("Unexpected result for media image thumbnail")
                error = .JsonParsing
                continue
            }
            let thumbnailData = ImageData(url: thumbnailUrl, width: thumbnailWidth, height: thumbnailHeight)
            
            let newMedia = MediaData(id: id, thumbnailData: thumbnailData)
            mediaToReturn.append(newMedia)
        }
        
        completion(media: mediaToReturn, error: error)
    }

}
