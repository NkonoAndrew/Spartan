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
import FirebaseDatabase

class PostEventViewController: UIViewController,  UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate {
    
    let db = Firestore.firestore()
    let ui = UIController()
    var userNewPost: Post!
    
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postContentField:UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userNewPost = Post()
        self.setupKeyboardDismiss()
        self.postContentField.delegate = self
        setUI()
        
        // Do any additional setup after loading the view.
    }
    
    /**
     In order to setup the camer mode, need to edit info.plist
     */
    @IBAction func touchCamera(_ sender: Any) {
        initImagePicker()
    }
    
    //add data to firebase
    @IBAction func touchPost(_ sender: Any) {
        uploadPostImage()
        uploadPostData()
        navigateToHomeView()
    }
    
    func setUI(){
        self.ui.setNavigationBarUI(vc: self)
        self.ui.setTextViewUI(view: postContentField)
        
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
    func navigateToHomeView(){
        print("Navigated to Home View Controller!")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabbarVC = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                // Marked Line to ask system to use the old behavior: Full screen
                tabbarVC.modalPresentationStyle = .fullScreen
                self.present(tabbarVC, animated: false, completion: nil)
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
     UIImagePickerController delegate
     */
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("imagePickerController is triggered!")
        var selectedImage: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
        } else if let
            originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
        }
        postImageView.image = selectedImage!
        picker.dismiss(animated: true, completion: nil)
    }
    // MARK: UITextView Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        // reset text to empty
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = ui.DETAILS_PLACE_HOLDER
            textView.textColor = UIColor.lightGray
        }
    }
    
    func setupKeyboardDismiss() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
}
