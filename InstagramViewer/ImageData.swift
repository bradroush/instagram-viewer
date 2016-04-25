//
//  ImageData.swift
//  InstagramViewer
//
//  Created by Brad Roush on 4/24/16.
//  Copyright © 2016 Brad Roush. All rights reserved.
//

import Foundation

struct ImageData {
    
    let url: String
    let width: Int
    let height: Int
    
    init(url: String, width: Int, height: Int) {
        self.url = url
        self.width = width
        self.height = height
    }
    
}
