//
//  SignUpViewController.swift
//  SparntanNet
//
//  Created by Bella Wei on 4/14/20.
//  Copyright © 2020 Bella Wei. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var ErrorSignUpLabel: UILabel!
    
    var userFirstName: String = ""
    var userLastName: String = ""
    var userEmail: String = ""
    var userPassword: String = ""
    let db = Firestore.firestore()
    var userObj: User!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupKeyboardDismiss()
        setUI()
    }
    
    func setupKeyboardDismiss() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    // create function to style all textfield
    func setUI(){
        // Hide the error label
        ErrorSignUpLabel.alpha = 0
        
        // Style all textfield
        UIController.styleTextField(firstNameTextField)
        UIController.styleTextField(lastNameTextField)
        UIController.styleTextField(emailTextField)
        UIController.styleTextField(passwordTextField)
        UIController.styleFilledButton(signUpButton)
    }
    
    func registerToDB(_ thisUID: String) {
        let ref: DocumentReference = self.db.collection("users").document(thisUID)
        ref.setData([
            "uid" : thisUID,
            "email": userEmail,
            "accName": userFirstName + " " + userLastName,
            "imageName": "default.png",
            "majorName": "Software Engineering",
            "userBio": "defaultbio"
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref.documentID)")
            }
        }
    }
    
    func validateFields() -> String? {
        // Check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields."
        }
        return nil
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        // Validate the fields
        let error = validateFields()
        if error != nil {
            showError(error!)
        }
        else {
            // Create the user
            Auth.auth().createUser(withEmail: self.userEmail, password: self.userPassword) { (authResult,err) in
                if err != nil {
                    // if there is error creating user, print error message
                    self.showError("Error creating User")
                }else if let result = authResult{
                    let profileChangeRequest = result.user.createProfileChangeRequest()
                    profileChangeRequest.displayName = self.userFirstName + " " + self.userLastName
                    profileChangeRequest.commitChanges { (error) in
                    }
                    self.registerToDB(result.user.uid)
                    self.transitionToHome()
                    
                }
            }
        }
    }
    
    func showError(_ message:String){
        ErrorSignUpLabel.text  = message
        ErrorSignUpLabel.alpha = 1
    }
    
    @IBAction func firstNameFilled(_ sender: UITextField) {
        if let firstName = sender.text {
            ErrorSignUpLabel.isHidden = true
            self.userFirstName = firstName
            sender.resignFirstResponder()
        }else {
            ErrorSignUpLabel.isHidden = false
            ErrorSignUpLabel.text = "Please enter your first Name"
        }
    }
    
    @IBAction func lastNameFilled(_ sender: UITextField) {
        if let lastName = sender.text {
            ErrorSignUpLabel.isHidden = true
            self.userLastName = lastName
            sender.resignFirstResponder()
        }else {
            ErrorSignUpLabel.isHidden = false
            ErrorSignUpLabel.text = "Please enter your last Name"
        }
    }
    
    
    @IBAction func emailFilled(_ sender: UITextField) {
        if let email = sender.text {
            ErrorSignUpLabel.isHidden = true
            self.userEmail = email
            sender.resignFirstResponder()
        }else {
            ErrorSignUpLabel.isHidden = false
        }
    }
    
    @IBAction func passwordFilled(_ sender: UITextField) {
        if let password = sender.text {
            if checkPassword(password: password) {
                print("valid password")
                ErrorSignUpLabel.isHidden = true
                self.userPassword = password
                sender.resignFirstResponder()
                
            } else {
                ErrorSignUpLabel.isHidden = false
                sender.text = ""
                self.userPassword = ""
                ErrorSignUpLabel.text = "Password needs to have at least 8 characters, 1 number and 1 capitalized letter"
            }
        } else {
            ErrorSignUpLabel.isHidden = false
            ErrorSignUpLabel.text = "Please choose a password"
        }
    }
    
    func transitionToHome(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabbarVC = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        // Marked Line to ask system to use the old behavior: Full screen
        tabbarVC.modalPresentationStyle = .fullScreen
        self.present(tabbarVC, animated: false, completion: nil)
    }
    
//    func checkUserInfo() -> Bool{
//        return (self.userEmail != "" && self.userLastName != "" && self.userPassword != "" && self.userFirstName != "")
//    }
    
    func checkPassword(password: String) -> Bool {
        /*
         RULES:
         - At least 8 characters
         - At least 1 number
         - At least 1 capitalized
         */
        
        //check if it contains character
        return (password.count>=8 && password.rangeOfCharacter(from: .decimalDigits) != nil && password.rangeOfCharacter(from: .uppercaseLetters) != nil)
    }
    
    
}
