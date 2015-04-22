//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Franck Ferront on 08/04/2015.
//  Copyright (c) 2015 UXperience. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL
    var title: String
    
     //Task 1: initializer
    init(filePathUrl: NSURL, title: String){
        self.filePathUrl = filePathUrl
        self.title = title
    }
    
}
