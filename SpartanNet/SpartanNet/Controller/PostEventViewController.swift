//
//  PostEventViewController.swift
//  SpartanNet
//
//  Created by Bella Wei on 4/3/20.
//  Copyright © 2020 Bella Wei. All rights reserved.
//

import UIKit
import Firebase

class PostEventViewController: UIViewController {
    let db = Firestore.firestore()
    
    @IBOutlet weak var contextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func touchPost(_ sender: Any) {
        let doc = db.collection("posts").document()
        doc.setData([
            "Context": self.contextField.text ?? "Default Context",
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
}
