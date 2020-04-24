//
//  PostEventViewController.swift
//  SparntanNet
//
//  Created by Bella Wei on 4/14/20.
//  Copyright © 2020 Bella Wei. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore

class PostEventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextViewDelegate {

    let db = Firestore.firestore()
    let ui = UIController()
    var userNewPost: Post!
    
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postContentField:UITextView!
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userNewPost = Post()
        self.postContentField.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func touchCamera(_ sender: Any) {
        initImagePicker()
    }
    /**
     Init image picker with alert controller.
     */
    func initImagePicker() {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .photoLibrary
        //image.sourceType = .camera
        image.allowsEditing = true
        self.present(image, animated: true) {
        }
    }
/**
     In order to setup the camer mode, need to edit info.plist
     */
 
    //add data to firebase
    @IBAction func touchPost(_ sender: Any) {
        uploadPostImage()
        uploadPostData()
    }
    
    func uploadPostData(){
        let doc = db.collection("posts").document()
        doc.setData([
            //"context":self.contextField.text ?? "Default context",
            "eventName":self.eventNameTextField.text ?? "Default eventname",
            "imageName":userNewPost.imageName,
            "content":self.postContentField.text ?? "Default content"
        ]){ err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func uploadPostImage(){
        if let image = ui.resized(view: postImageView, targetSize: CGSize(width: 374.0, height: 218.0)) {
            let imageName = "images/\(NSUUID().uuidString).png"
            print("imageName = \(imageName), before upload" )
            self.userNewPost.imageName = imageName
            let imageRef = Storage.storage().reference().child(imageName)
            
            if let uploadData = image.pngData() {
                imageRef.putData(uploadData, metadata: nil) { metadata, error in
                    if error != nil {
                        print("Error: \(error.debugDescription)")
                        return
                    } else {
                        print("Sucessfully upload image.")
                        self.uploadPostData()
                        print("path = \(imageRef.fullPath), after upload")
                    }
                }
            }
        }
    }
    
    
    
}
