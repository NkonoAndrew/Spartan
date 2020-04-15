
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
    
    // Default constructor
    init() {
        self.context = "Default context"
    }
    
    // Data parsing
    init(data: [String: Any]) {
    
       // self.context = data["context"] ?? "Default context" as! String
        if let contexts = data["context"] {
            self.context = contexts as! String
        }else {
         self.context = "Default context"
        }
        
    }
    
    // For debug
    func printPost() {
        print("=======================")
        print("context: \(self.context)")
        print("=======================")
    }

}

