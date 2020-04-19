//
//  ViewController.swift
//  SparntanNet
//
//  Created by Bella Wei on 3/31/20.
//  Copyright © 2020 Bella Wei. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController, GIDSignInDelegate{
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabbarVC = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            // Marked Line to ask system to use the old behavior: Full screen
            tabbarVC.modalPresentationStyle = .fullScreen
            self.present(tabbarVC, animated: false, completion: nil)
        }
    }
    
    
    @IBAction func GIDSigninButton(_ sender: GIDSignInButton) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
        GIDSignIn.sharedInstance()?.delegate = self
        
        setUpElements()
        
    }
    
    func setUpElements(){
        UIController.styleFilledButton(signUpButton)
        UIController.styleHollowButton(loginButton)
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            // ...
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    
    
    
}

