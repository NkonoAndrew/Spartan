//
//  ContactViewController.swift
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

class ContactViewController: UIViewController {
    
    let db = Firestore.firestore()
    let ui = UIController()
    let alertService = AlertService()
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var feedbackTextView: UITextView!
    
    @IBOutlet weak var ErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Contact"
        self.setupKeyboardDismiss()
        setUpElements()
        setUI()
        // Do any additional setup after loading the view.
    }
    func setUpElements(){
        ErrorLabel.alpha = 0
    }
    func setUI(){
        self.ui.setTextViewUI(view: feedbackTextView)
    }
    
    func validateFields() -> String? {
        // Check that all fields are filled in
        if  userNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            userEmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            feedbackTextView.text.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields."
        }
        return nil
    }
    
    @IBAction func sendMessageButton(_ sender: Any) {
        // Vaidate the feilds
        
        let error = validateFields()
        if error != nil {
            showError(error!)
        }
        else {
            //        let username  = self.userNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            //        let useremail = self.userEmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let doc = db.collection("feedback").document()
            doc.setData([
                "userName":self.userNameTextField.text ?? "Default username",
                "userEmail":self.userEmailTextField.text ?? "Default useremail",
                "userContent":self.feedbackTextView.text ?? "Deault usercontent"
            ]){ err in
                if let err = err {
                    print("Error submiting feedback:\(err)")
                }else {
                    print("Feedback Successfully written!")
                    //                     let alert = UIAlertController(title: " ", message: "Thank you for your feedback", preferredStyle: .alert)
                    //                    self.present(alert, animated: true, completion: nil)
                    
                    let alertVC = self.alertService.alert()
                    self.present(alertVC, animated: true, completion: nil)
                    //self.navigateToHomeView()
                    
                    
                    
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
    
    func showError(_ message:String){
        ErrorLabel.text  = message
        ErrorLabel.alpha = 1
    }
    func setupKeyboardDismiss() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    
}
