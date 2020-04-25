//
//  HomeViewController.swift
//  SparntanNet
//
//  Created by Bella Wei on 3/25/20.
//  Copyright © 2020 Bella Wei. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseDatabase

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    private var posts = [Post]()
    private var db = Firestore.firestore()
    var isFetching: Bool = false
    let ui = UIController()
    
    
    @IBOutlet weak var eventTable: UITableView!
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        navigateToviewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchPosts()
        
        // Do any additional setup after loading the view.
    }
    /**
     Read data from database
     */
    func fetchPosts() {
    posts.removeAll()
    
        db.collection("posts").getDocuments{ (snapshot, error) in
            if let err = error {
                debugPrint("Error fetching does: \(err)")
            } else {
                print("Sucessfully fetched posts.")
                for document in snapshot!.documents {
                    print("debug = \(document.data())")
                   // print("imageName = \(post.imageName)")
                    let newPost = Post(data: document.data())
                    self.posts.append(newPost)
                    newPost.printPost()
                }
                self.initTable()
                self.isFetching = false
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
        
        // load cell data
        if indexPath.row > posts.count {
            return UITableViewCell()
        }
        let cell = eventTable.dequeueReusableCell(withIdentifier: "postCell") as? HomeTableViewCell ?? HomeTableViewCell(style: .default, reuseIdentifier: "postCell") as HomeTableViewCell
        
        // TODO:
        //  cell.configureCell(post: posts[indexPath.row])
       // cell.postContent.tag = indexPath.row
        if (posts.count >= 1) {
            let curPost = posts[indexPath.row]
            cell.setPost(post: curPost)
            curPost.printPost()
        }
        
        return cell
    }
     //MARK: UIScrollView Delegate
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            if offsetY > contentHeight - scrollView.frame.height {
//                if !isFetching {
//                    fetchPosts()
                    self.ui.setTableActicityIndicator(tv: eventTable, isTop: false)
//                }
            }
        }
    
        func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                       withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            if (velocity.y > 0) {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                if let nc = self.navigationController {
                    self.ui.setTransparentNavigationBar(nc: nc)
                }
            } else {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            }
        }
        
        func fetch_Post(){
        isFetching = true
        self.fetchPosts()
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
}
