//
//  Contact.swift
//  SparntanNet
//
//  Created by Bella Wei on 4/25/20.
//  Copyright © 2020 Bella Wei. All rights reserved.
//

import Foundation
import UIKit

class Contact {
    
    var userName: String
    var userEmail: String
    var userContent:String
    
    // Default constructor
    init() {
        
        self.userName = "DefaultEventName"
        self.userEmail = "DefaultEmail"
        self.userContent = "DefaultUserContent"
        
    }
    
    // Data parsing
    init(data: [String: Any]) {
        
        if let userNames = data["userName"] {
            self.userName = userNames as! String
        } else {
            self.userName = "default username"
        }
        
        if let useremails = data["userEmail"] {
            self.userEmail = useremails as! String
        } else {
            self.userEmail = "Default useremail"
        }
        
        if let contents = data["userContent"] {
            self.userContent = contents as! String
        } else {
            self.userContent = "Default usercontent"
        }
    }
    
    // For debug
    func printPost() {
        print("=======================")
        // print("context: \(self.context)")
        
        print("eventname: \(self.userName)")
        print("imageName: \(self.userEmail)")
        print("content: \(self.userContent)")
        
        print("=======================")
        
        
    }
    
}

