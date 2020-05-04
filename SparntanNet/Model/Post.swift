
//
//  Post.swift
//  SparntanNet
//
//  Created by Bella Wei on 4/13/20.
//  Copyright © 2020 Bella Wei. All rights reserved.
//

import Foundation
import UIKit

class Post {
    var uID:String
    var imageName: String
    var eventName: String
    var content:String
    var eventDate:String
    
    // Default constructor
    init() {
        self.uID = "00000000"
        self.imageName = "default.png"
        self.eventName = "DefaultEventName"
        self.eventDate = "DeaultDate"
        self.content = "DefaultContent"
    }
    
    // Data parsing
    init(data: [String: Any]) {
        
        //   self.uID = data["uid"]  as! String
        
        if let uIDs = data["uid"] {
            self.uID = uIDs as! String
        } else {
            self.uID = "default.png"
        }
        // self.context = data["context"] ?? "Default context" as! String
        if let imageNames = data["imageName"] {
            self.imageName = imageNames as! String
        } else {
            self.imageName = "default.png"
        }
        
        if let eventnames = data["eventName"] {
            self.eventName = eventnames as! String
        } else {
            self.eventName = "Default eventname"
        }
        
         if let eventdatess = data["eventDate"] {
            self.eventDate = eventdatess as! String
        } else {
            self.eventDate = "Default eventdate"
        }
        
        if let contents = data["content"] {
            self.content = contents as! String
        } else {
            self.content = "Default content"
        }
    }
    
    // For debug
    func printPost() {
        print("=======================")
        // print("context: \(self.context)")
        print("uID: \(self.uID)")
        print("eventname: \(self.eventName)")
        print("imageName: \(self.imageName)")
        print("eventDate: \(self.eventDate)")
        print("content: \(self.content)")
        
        print("=======================")
        
        
    }
    
}
