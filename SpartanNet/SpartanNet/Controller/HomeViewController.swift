//
//  HomeViewController.swift
//  SpartanNet
//
//  Created by Bella Wei on 3/31/20.
//  Copyright © 2020 Bella Wei. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    let db = Firestore.firestore()
    
    @IBOutlet weak var contextLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // read data from database
    db.collection("posts").getDocuments() { (querySnapshot, err) in
    if let err = err {
        print("Error getting documents: \(err)")
    } else {
        for document in querySnapshot!.documents {
            print("\(document.documentID) => \(document.data())")
            self.contextLabel.text = document.data()["Context"] as! String
        }
    }
}
        
        
    }
    
    // send data to firebase
    
}
