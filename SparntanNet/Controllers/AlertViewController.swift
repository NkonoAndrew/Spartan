//
//  AlertViewController.swift
//  SparntanNet
//
//  Created by Bella Wei on 4/27/20.
//  Copyright © 2020 Bella Wei. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {

    @IBOutlet var alertView: UIView!
    @IBOutlet var successImg: UIView!
    @IBOutlet weak var alertTextLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneButton(_ sender: Any) {
        self.navigateToHomeView()
    }
    
    func navigateToHomeView(){
        print("Navigated to Home View Controller!")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabbarVC = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        // Marked Line to ask system to use the old behavior: Full screen
        tabbarVC.modalPresentationStyle = .fullScreen
        self.present(tabbarVC, animated: false, completion: nil)
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
