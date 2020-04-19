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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    // create function to style all textfield
    func setUpElements(){
        // Hide the error label
        ErrorSignUpLabel.alpha = 0
        
        // Style all textfield
        UIController.styleTextField(firstNameTextField)
        UIController.styleTextField(lastNameTextField)
        UIController.styleTextField(emailTextField)
        UIController.styleTextField(passwordTextField)
        UIController.styleFilledButton(signUpButton)
        
        
    }
    
    func validateFields() -> String? {
        // Check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields."
        }
        // Check if the pasword is secure
        let cleanedPassword = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if UIController.isPasswordValid(cleanedPassword!) == false {
            // Password is Not Secure enough
            return "Password must be contains at least 8 characters, a speical character and a number."
        }
        return nil
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        // Validate the fields
        let error = validateFields()
        if error != nil {
        
        // there is sth wrong with the field, show error messages
        showError(error!)
        }
        else {
            // Before create a user, create cleaned versions of the data
            let firstname = self.firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastname  = self.lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email     = self.emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let password  = self.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            // Create the user
            Auth.auth().createUser(withEmail: email!, password: password!) { (result,err) in
            
            if err != nil {
                // if there is error creating user, print error message
                self.showError("Error creating User")
            }
            else {
                // User was created successfully, now store the first name and last name in the firebase
                let db = Firestore.firestore()
                
                db.collection("users").addDocument(data: ["firstname":firstname,"lastname":lastname,"uid":result?.user.uid as Any])
                {(error) in
                        if error != nil {
                        self.showError("Error saving User Data")
                    }
                
                }
                // Transition to Home View
                self.transitionToHome()
            }
          }
        }
}
    
    
    func showError(_ message:String){
        ErrorSignUpLabel.text  = message
        ErrorSignUpLabel.alpha = 1
    }
    
    func transitionToHome(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabbarVC = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            // Marked Line to ask system to use the old behavior: Full screen
            tabbarVC.modalPresentationStyle = .fullScreen
            self.present(tabbarVC, animated: false, completion: nil)
    }
    
}
