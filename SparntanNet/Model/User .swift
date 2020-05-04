//
//  User .swift
//  SparntanNet
//
//  Created by Bella Wei on 4/30/20.
//  Copyright © 2020 Bella Wei. All rights reserved.
//

import Foundation
import FirebaseAuth

class User {
    var uid: String
    var majorName: String
    var accName: String
    var imageName: String
    //var posts: [String]?
  //  var userBio: String
    
    // Default constructor
    init() {
        self.uid = "00000000"
        self.majorName = "defaultmajorName"
        self.accName = "defaultName"
        self.imageName = "yellow-bird.png"
        //self.posts = [String]()
      //  self.userBio = "defualtbio"
    }
    
    // Data reading
    init(data:[String: Any]) {
       // self.uid = data["uid"] as! String
       if let uids = data["uid"] {
            self.uid = uids as! String
        } else {
            self.uid = "00000000"
        }
        
       // self.majorName = data["majorName"] as! String
       
       if let majornames = data["majorName"] {
            self.majorName = majornames as! String
        } else {
            self.majorName = "defaultmajorName"
        }
        
       // self.accName = data["accName"] as! String
       
       if let accnamess = data["accName"] {
            self.accName = accnamess as! String
        } else {
            self.accName = "defaultName"
        }
        
       // self.imageName = data["imageName"] as! String
       // self.posts = data["posts"] as? [String]
       if let imagenames = data["imageName"] {
            self.imageName = imagenames as! String
        } else {
            self.imageName = "yellow-bird.png"
        }
      //  self.userBio = data["userBio"] as! String
    }

    func printUser() {
        print("=======================")
        print("uid: \(self.uid)")
        print("majorName: \(self.majorName)")
        print("accName: \(self.accName)")
        print("imageName: \(self.imageName)")
       // print("userBio: \(self.userBio)")
        print("=======================")
    }

    /*when log in, init with data from firebase
    init()
     */
}
