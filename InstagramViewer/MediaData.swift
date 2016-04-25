//
//  Media.swift
//  InstagramViewer
//
//  Created by Brad Roush on 4/24/16.
//  Copyright © 2016 Brad Roush. All rights reserved.
//

import Foundation

struct MediaData {
    
    let id: String
    let thumbnailData: ImageData
    
    init(id: String, thumbnailData: ImageData) {
        self.id = id
        self.thumbnailData = thumbnailData
    }
    
}
