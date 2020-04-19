//
//  LoginViewController.swift
//  SparntanNet
//
//  Created by Bella Wei on 4/14/20.
//  Copyright © 2020 Bella Wei. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {


    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLoginLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements(){
        // Hide the error label
        errorLoginLabel.alpha = 0
        
        // Styple the elements
        UIController.styleTextField(emailTextField)
        UIController.styleTextField(passwordTextField)
        UIController.styleFilledButton(loginButton)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        // Validate Text Fields
       let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
       let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
       
        // Signing the user
        Auth.auth().signIn(withEmail: email!, password: password!) {(result, error) in
            if error != nil {
                self.errorLoginLabel.text = error!.localizedDescription
                self.errorLoginLabel.alpha = 1
            }
            else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabbarVC = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                // Marked Line to ask system to use the old behavior: Full screen
                tabbarVC.modalPresentationStyle = .fullScreen
                self.present(tabbarVC, animated: false, completion: nil)
            }
        }
    }
    
}

