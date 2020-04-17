//
//  HomeViewController.swift
//  SparntanNet
//
//  Created by Bella Wei on 4/14/20.
//  Copyright © 2020 Bella Wei. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    private var posts = [Post]()
    private var db = Firestore.firestore()
    
    @IBOutlet weak var eventTable: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetch_posts()
        
        // Do any additional setup after loading the view.
    }
    
    
    /**
     Read data from database
     */
    func fetch_posts() {
        db.collection("posts").getDocuments{ (snapshot, error) in
            if let err = error {
                debugPrint("Error fetching does: \(err)")
            } else {
                print("Sucessfully fetched posts.")
                for document in snapshot!.documents {
                    //print(document.data())
                    let newPost = Post(data: document.data())
                    self.posts.append(newPost)
                }
                self.initTable()
            }
        }
    }
    
    /**
     Initialize table with fetched data
     */
    func initTable(){
        eventTable.delegate = self
        eventTable.dataSource = self
        eventTable.reloadData()
    }
    // MARK: UITableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row > posts.count {
            return UITableViewCell()
        }
        let cell = eventTable.dequeueReusableCell(withIdentifier: "postCell") as? HomeTableViewCell ?? HomeTableViewCell(style: .default, reuseIdentifier: "postCell") as HomeTableViewCell
        cell.configureCell(post: posts[indexPath.row])
        
        return cell
    }
}
