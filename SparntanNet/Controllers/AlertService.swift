//
//  AlertService.swift
//  SparntanNet
//
//  Created by Bella Wei on 4/27/20.
//  Copyright © 2020 Bella Wei. All rights reserved.
//

import Foundation
import UIKit

class AlertService {
    
    func alert()-> AlertViewController {
        let storyboard = UIStoryboard(name: "AlertStoryboard", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
        return alertVC
    }
}
