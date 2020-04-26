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
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var feedbackTextView: UITextView!
    
    @IBOutlet weak var ErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Contact"
        setUpElements()
        // Do any additional setup after loading the view.
    }
    func setUpElements(){
        ErrorLabel.alpha = 0
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
                }
                
                
            }
        }
    }
    
    func showError(_ message:String){
        ErrorLabel.text  = message
        ErrorLabel.alpha = 1
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
