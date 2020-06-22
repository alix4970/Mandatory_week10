//
//  Note.swift
//  Mandatory10
//
//  Created by Ali Al sharefi on 10/06/2020.
//  Copyright © 2020 Ali Al sharefi. All rights reserved.
//

import Foundation

class Note {
    // Fields
    var id:String
    var head:String
    var body:String
    var imageID:String
    
    // Initializer (Constructor)
    init(id:String, head:String, body:String, imageID:String) {
        self.id = id
        self.head = head
        self.body = body
        self.imageID = imageID
    }
    
    func setImageID(imageID:String){
        self.imageID = imageID
    }
    
    
    
}
