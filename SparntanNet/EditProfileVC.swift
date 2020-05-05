//
//  EditProfileVC.swift
//  SparntanNet
//
//  Created by Bella Wei on 4/30/20.
//  Copyright © 2020 Bella Wei. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Accelerate

class EditProfileVC: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {
    
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var userMajorField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var deleteAccButton: UIButton!
    
    var curUser: User!
    var isImageChanged: Bool!
    let ui = UIController()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isImageChanged = false
        self.initUserData()
        self.setUI()
        self.setupKeyboardDismiss()
        
        // Do any additional setup after loading the view.
    }
    
    func setUI(){
        self.userImageView.contentMode = .scaleToFill
        self.ui.setCircularView(view: userImageView)
        self.ui.setNavigationBarUI(vc: self)
        self.messageLabel.isHidden = true
    }
    
    /**
     Init current user data.
     */
    func initUserData() {
        if let user = Auth.auth().currentUser {
            let ref = Firestore.firestore().collection("users").document(user.uid)
            ref.getDocument { document, error in
                if let doc = document, document!.exists {
                    if let data = doc.data() {
                        self.curUser = User(data: data)
                        self.curUser.printUser()
                        self.initProfile()
                    }
                } else {
                    print("Document does not exist.")
                }
            }
        }
    }
    
    /**
     Init this profile view with current user data.
     */
    func initProfile() {
        userNameField.text = curUser.accName
        userMajorField.text = curUser.majorName
        downloadImage()
    }
    
    /**
     Download image from firebase
     */
    func downloadImage() {
        let imageRef = Storage.storage().reference().child(curUser.imageName)
        imageRef.getData(maxSize: ui.MAX_SIZE) { data, error in
            if error != nil {
                print("Error: \(error.debugDescription)")
                return
            }
            if let data = data {
                self.userImageView.image = UIImage(data: data)
            }
        }
    }
    
    @IBAction func editAccName(_ sender: Any) {
        curUser.accName = userNameField.text ?? ""
    }
    @IBAction func editMajorName(_ sender: Any) {
        curUser.majorName = userMajorField.text ?? ""
    }
    
    @IBAction func touchSave(_ sender: Any) {
        if let newName = userNameField.text,
            let newmajorName = userMajorField.text {
            curUser.accName = newName
            curUser.majorName = newmajorName
        }
        updateUser()
    }
    
    
    @IBAction func touchCamera(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .photoLibrary
        image.allowsEditing = true
        self.present(image,animated: true) {}
    }
    
    func setMessageLabel(isError: Bool, message: String) {
        self.messageLabel.text = message
        if isError {
            self.messageLabel.textColor = UIColor.red
        } else {
            self.messageLabel.textColor = UIColor.green
        }
        self.messageLabel.isHidden = false
    }
    
    func updateUser() {
        print("Updating users collection.")
        let ref = Firestore.firestore().collection("users").document(curUser.uid)
        ref.updateData([
            "accName" : curUser.accName,
            "majorName" : curUser.majorName,
            "imageName" : curUser.imageName
        ]) { error in
            if let err = error {
                print ("Error: \(err)")
            } else {
                print("Sucessfully update user profile.")
                if (self.isImageChanged) {
                    self.uploadImage()
                } else {
                    self.navigateToProfile()
                }
            }
        }
    }
    
    func uploadImage() {
        if let image = ui
            .resized(view: userImageView,
                     targetSize: CGSize(
                        width: userImageView.bounds.width,
                        height: userImageView.bounds.height)) {
            let imageRef = Storage.storage().reference().child(curUser.imageName)
            if let uploadData = image.pngData() {
                imageRef.putData(uploadData, metadata: nil) { metadata, error in
                    if error != nil {
                        print("Error: \(error.debugDescription)")
                        return
                    } else {
                        print("Sucessfully upload image.")
                        self.navigateToProfile()
                    }
                }
            }
        }
    }
    
    // MARK: ImagePicker Delegate
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
            let newImageName = "images/\(NSUUID().uuidString).png"
            self.curUser.imageName = newImageName
            self.isImageChanged = true
            
        } else if let
            originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
        }
        userImageView.image = selectedImage!
        picker.dismiss(animated: true, completion: nil)
    }
    
    func setupKeyboardDismiss() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    // TO DO Delete
    
    @IBAction func touchDeleteAcc(_ sender: Any) {
        let delAlert = UIAlertController(title: "Delete Account", message: "Are you sure you want to permanently delete your account? This action cannot be reversed.", preferredStyle: .alert)
        
        let delete = UIAlertAction(title:"Delete", style: .destructive){ (_)in
            self.deleteUser(user: self.curUser)
            if let user = Auth.auth().currentUser{
                user.delete { error in
                    if let err = error {
                        self.setMessageLabel(isError: true, message: err.localizedDescription)
                    }else{
                        self.navigateToviewController()
                    }
                    
                }
            }
            
        }
        let cancel = UIAlertAction(title:"I'll stay!", style: .cancel) {(_) in}
        delAlert.addAction(cancel)
        delAlert.addAction(delete)
        
        self.present(delAlert, animated: true, completion: nil)
        
    }
    func deleteUser(user: User){
        Firestore.firestore().collection("users").document(user.uid).delete() {err in
            if err != nil {
                print("could not delete user")
            }else {
                print("User successfully removed!")
            }
        }
    }
    func navigateToProfile(){
        print("Navigated to Profile View Controller")
        let mainStoryboard =  UIStoryboard(name: "Main", bundle: nil)
        let loginVC = mainStoryboard
           .instantiateViewController(identifier:
               "UserProfileViewController") as! UserProfileViewController
        loginVC.modalPresentationStyle = .fullScreen
        self.navigationController?.popViewController(animated: true)
    }
    
    func navigateToviewController(){
        print("Navigated to ViewController")
        let mainStoryboard =  UIStoryboard(name: "Main", bundle: nil)
        let VC = mainStoryboard
            .instantiateViewController(identifier:
                "ViewController") as! ViewController
        VC.modalPresentationStyle = .fullScreen
        present(VC, animated: true, completion: nil)
    }
}







