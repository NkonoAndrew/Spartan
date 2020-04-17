
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
    var context: String
    var eventname: String
    
    // Default constructor
    init() {
        self.context = "Default context"
        self.eventname = "Default eventname"
    }
    
    // Data parsing
    init(data: [String: Any]) {
    
       // self.context = data["context"] ?? "Default context" as! String
        if let contexts = data["context"] {
            self.context = contexts as! String
        }else {
         self.context = "Default context"
        }
        
         if let eventnames = data["eventname"] {
            self.eventname = eventnames as! String
        }else {
         self.eventname = "Default eventname"
        
        
    }
    
    // For debug
    func printPost() {
        print("=======================")
        print("context: \(self.context)")
        print("=======================")
    }

}

}
