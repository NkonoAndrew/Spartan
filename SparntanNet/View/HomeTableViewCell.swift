//
//  HomeTableViewCell.swift
//  SparntanNet
//
//  Created by Bella Wei on 4/14/20.
//  Copyright © 2020 Bella Wei. All rights reserved.
//

import UIKit
import FirebaseFirestore

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var eventLabel: UILabel!
    func configureCell(post: Post) {
    
       self.eventLabel.text = post.context
       //self.eventLabel.text = "hello world"
    }
}
