//
//  PostEventViewController.swift
//  SparntanNet
//
//  Created by Bella Wei on 4/14/20.
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
    
    //add data to firebase
    @IBAction func touchPost(_ sender: Any) {
        let doc = db.collection("posts").document()
        doc.setData(["context":self.contextField.text ?? "Default context",]){ err in
                if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
  

}
