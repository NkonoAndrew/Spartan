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
        postContent.isUserInteractionEnabled = false
        postContent.text = post.content
        downloadImage(imageName: post.imageName)
        downloadImage(uid: post.uID)
        
        
   
      // self.eventLabel.text = "hello world"
//    self.postImage.image = image
//    self.eventNameTableLabel.text = post.eventName
//    self.
//
    
    }
    
    func downloadImage(imageName: String) {
        let MAX_SIZE: Int64 =  1 * 1024 * 1024
        let imageRef = Storage.storage().reference().child(imageName)
        imageRef.getData(maxSize: MAX_SIZE) { data, error in
            if let err = error {
                print("\(err)")
                return
            }
            if data != nil {
                print("Sucessfully download image.")
               // self.postImage.image = UIImage(data: data)
                
            }
        }
    }
    func downloadImage(uid: String) {
        let ref = Firestore.firestore().collection("users").document(uid)
        ref.getDocument { document, error in
            if let err = error {
                print("\(err)")
            } else {
                let imageName = document?.get("imageName")
                self.downloadImage(imageName: imageName as! String)
            }
        }
    }
}
