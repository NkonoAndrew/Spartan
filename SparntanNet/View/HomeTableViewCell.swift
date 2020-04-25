//
//  HomeTableViewCell.swift
//  SparntanNet
//
//  Created by Bella Wei on 4/14/20.
//  Copyright © 2020 Bella Wei. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseDatabase

class HomeTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var postImage:UIImageView!
    @IBOutlet weak var eventNameTableLabel: UILabel!
    @IBOutlet weak var postContent:UITextView!
    
    let ui = UIController()
    var post = Post()
    
    
    func setPost(post: Post) {
        self.post = post
        postContent.text = post.content
        print("eventName = \(post.eventName)")
        eventNameTableLabel.text = post.eventName
        print("imageName = \(post.imageName)")
        downloadImage(imageName: post.imageName)
        
        downloadImage(uid: post.uID)
        
        
        
        //      // self.eventLabel.text = "hello world"
        //        self.postImage.image = post.imageName
        //        self.eventNameTableLabel.text = post.eventName
        //        self.postContent.text =
        ////    self.
        //
        
    }
    
    func downloadImage(imageName: String) {
        
        let imageRef = Storage.storage().reference().child(imageName)
        imageRef.getData(maxSize: ui.MAX_SIZE) { data, error in
            if let err = error {
                print("\(err)")
                return
            }
            if let data = data {
                self.postImage.image = UIImage(data: data)
                print("Sucessfully download image.")
                // self.postImage.image = UIImage(data: data)
                
            }
        }
    }
    
    func downloadImage(uid: String) {
        let ref = Firestore.firestore().collection("posts").document(uid)
        ref.getDocument { document, error in
            if let err = error {
                print("\(err)")
            } else {
                if let imageName = document?.get("imageName"){
                    self.downloadImage(imageName: imageName as! String)
                }else {
                    self.downloadImage(imageName: "default.png")
                }
            }
        }
    }
}
