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
    let datePicker = UIDatePicker()
    
    var userNewPost: Post!
    var curUser: User!
    
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postContentField:UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userNewPost = Post()
        self.setupKeyboardDismiss()
        self.postContentField.delegate = self
        createDatePicker()
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
        navigateToHomeView()
    }
    
    func createDatePicker(){
        dateTextField.textAlignment = .center
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bar button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        dateTextField.inputAccessoryView = toolbar
        
        // assign date picker to the text field
        dateTextField.inputView = datePicker
        //  Format
        datePicker.datePickerMode = .date
    }
    
    @objc func donePressed(){
        //  Format
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        dateTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    
    func setUI(){
        postImageView.image = UIImage(named: "sjsufootball")
        self.ui.setNavigationBarUI(vc: self)
        self.ui.setTextViewUI(view: postContentField)
        
    }
    /**
     Retrieve current user data
     */
    //    func initCurUserData() {
    //        print("Initializing current user data.")
    //        if let user = Auth.auth().currentUser {
    //            let ref = Firestore.firestore().collection("users").document(user.uid)
    //            ref.getDocument { document, error in
    //
    //                if let doc = document, document!.exists {
    //                    if let data = doc.data() {
    //                        self.curUser = User(data:data)
    //                        //self.curUser.printUser()
    //                    }
    //                } else {
    //                    print("Document does not exist.")
    //                }
    //            }
    //        } else {
    //            print("Currently has no user signed in.")
    //        }
    //    }
    
    func uploadPostData(){
        let doc = db.collection("posts").document()
        doc.setData([
            //"context":self.contextField.text ?? "Default context",
            "eventName":self.eventNameTextField.text ?? "Default eventname",
            "imageName":userNewPost.imageName,
            "content":self.postContentField.text ?? "Default content",
            "eventDate":self.dateTextField.text ?? "Default eventdate",
            "timeStamp":Timestamp()
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
