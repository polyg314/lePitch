//
//  RecordedAudio.swift
//  Le Pitch
//
//  Created by Paul Gaudin on 11/13/15.
//  Copyright © 2015 yours truly. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{

    var filePathUrl: NSURL!
    var title: String!
    
    init(filePath: NSURL, title: String) {
        self.filePathUrl = filePath
        self.title = title
    }
    
}