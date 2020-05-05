//
//  ViewController.swift
//  SparntanNet
//
//  Created by Bella Wei on 3/31/20.
//  Copyright © 2020 Bella Wei. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import AVFoundation
import GoogleSignIn
import FacebookLogin
import FacebookCore
import FBSDKCoreKit

class ViewController: UIViewController, GIDSignInDelegate{
    
    

    var videoPlayer: AVPlayer?
    var videoPlayerLayer: AVPlayerLayer?
    
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
        if let acessToken = AccessToken.current,
            !acessToken.isExpired {
        print("User already logged into facebook")
        print(acessToken)
        }
        
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
        GIDSignIn.sharedInstance()?.delegate = self
        
        setUpElements()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        // set up video player in the background
        setUpVideo()
}
    
    func setUpElements(){
        UIController.styleFilledButton(signUpButton)
        UIController.styleHollowButton(loginButton)
    }
    
    func setUpVideo(){
        // Get the path to the resource in the boundle
        guard let path = Bundle.main.path(forResource: "intro", ofType: "mov") else{
            return
        }
        // Create a URL from it
        let url = URL(fileURLWithPath: path)
        
        // Create the video player item
        let item = AVPlayerItem(url: url)
        
        // Create the player
        videoPlayer = AVPlayer(playerItem: item)
        
        // Create the layer
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
        
        // Adjust the size and frame
        
//        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.size.width*1.5, y: 0, width: self.view.frame.size.width*4, height: self.view.frame.size.height)

        videoPlayerLayer!.frame = self.view.bounds
        videoPlayerLayer!.videoGravity = .resizeAspectFill
        
          // add to the view and play it
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        videoPlayer?.playImmediately(atRate: 0.3)
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
    
    @IBAction func fbAction(_ sender: Any) {
            let loginManager = LoginManager()
            loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
                if let error = error {
                    print("Failed to login: \(error.localizedDescription)")
                    return
                }
                
                guard let accessToken = AccessToken.current else {
                    print("Failed to get access token")
                    return
                }
     
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                
                // Perform login by calling Firebase APIs
                Auth.auth().signIn(with: credential, completion: { (user, error) in
                    if let error = error {
                        print("Login error: \(error.localizedDescription)")
                        let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(okayAction)
                        self.present(alertController, animated: true, completion: nil)
                        return
                    }else {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let tabbarVC = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                        // Marked Line to ask system to use the old behavior: Full screen
                        tabbarVC.modalPresentationStyle = .fullScreen
                        self.present(tabbarVC, animated: false, completion: nil)
                    }
                
                })
     
            }
        }

}

