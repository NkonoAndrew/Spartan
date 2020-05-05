//
//  UserProfileViewController.swift
//  SparntanNet
//
//  Created by Bella Wei on 4/30/20.
//  Copyright © 2020 Bella Wei. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
class UserProfileViewController: UIViewController {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileMajorLabel: UITextField!
    
    var curUser: User!
    var posts: [Post] = []
    var isFetching: Bool = false
    let ui = UIController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUserData()
        self.setUI()
    }
    @IBAction func logOutButtonTapped(_ sender: Any) {
        navigateToviewController()
    }
    
    func initUserData() {
        if let user = Auth.auth().currentUser {
            let ref = Firestore.firestore().collection("users").document(user.uid)
            ref.getDocument { data, error in
                if let doc = data, data!.exists {
                    self.curUser = User(data: doc.data()!)
                    
                    self.initProfile()
                    // self.initPosts()
                } else {
                    print("Document does not exist")
                }
            }
        } else {
            print("Currently has no user signed in.")
        }
    }
    
    func initProfile() {
        profileNameLabel.text = curUser.accName
        profileMajorLabel.text = curUser.majorName
        initProfilePic()
    }
    func initProfilePic() {
        let imageRef = Storage.storage().reference().child(curUser.imageName)
        imageRef.getData(maxSize: ui.MAX_SIZE) { data, error in
            if error != nil {
                print("Error: \(error.debugDescription)")
                return
            }
            if let data = data {
                self.profileImage.image = UIImage(data: data)
            }
        }
    }
    /**
     VC navigating
     */
    func navigateToviewController(){
        print("Navigated to ViewController")
        let mainStoryboard =  UIStoryboard(name: "Main", bundle: nil)
        let loginVC = mainStoryboard
            .instantiateViewController(identifier:
                "ViewController") as! ViewController
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }
    /**
     UI setting.
     */
       func setUI() {
        self.ui.setNavigationBarUI(vc: self)
  //      self.profileImage.contentMode = .scaleAspectFill
//        self.ui.setCircularView(view: profileImage)
//        self.ui.setProfileView(view: profileImage)
    }
}
