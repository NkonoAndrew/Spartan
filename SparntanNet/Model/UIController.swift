//
//  UIController.swift
//  SparntanNet
//
//  Created by Bella Wei on 4/18/20.
//  Copyright © 2020 Bella Wei. All rights reserved.
//

import Foundation
import UIKit

class UIController {
    let MAX_SIZE: Int64 =  1 * 1024 * 1024
    let DETAILS_PLACE_HOLDER = "Add Details Here"
    
    static func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    func setNavigationBarUI(vc: UIViewController) {
        let nvBar = vc.navigationController?.navigationBar
        nvBar?.barStyle = .default
        nvBar?.tintColor = UIColor.init(displayP3Red: 0.22, green: 0.50, blue: 0.54, alpha: 1.0)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "yellow-bird")
        imageView.image = image
        vc.navigationItem.titleView = imageView
    }
    
       func setTextViewUI(view: UITextView) {
        view.text = self.DETAILS_PLACE_HOLDER
        view.textColor = UIColor.lightGray
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 8.0
    }
    func setTransparentNavigationBar(nc: UINavigationController) {
        nc.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nc.navigationBar.shadowImage = UIImage()
        nc.navigationBar.isTranslucent = true
        nc.view.backgroundColor = .clear
    }
    
    func resized(view: UIImageView, targetSize: CGSize) -> UIImage? {
        var resizedImage: UIImage?
        
        if let image = view.image {
            let size = image.size
            let widthRatio = targetSize.width / size.width
            let heightRatio = targetSize.height / size.height
            
            print(image.size)
            var canvas: CGSize
            if widthRatio > heightRatio {
                canvas = CGSize(width: image.size.width * heightRatio,
                                height: image.size.height * heightRatio)
            } else {
                canvas = CGSize(width: image.size.width * widthRatio,
                                height: image.size.height * widthRatio)
            }
            let rect = CGRect(x: 0, y: 0, width: canvas.width, height: canvas.height)
            print("canvas", canvas)
            UIGraphicsBeginImageContextWithOptions(canvas, false, 1.0)
            image.draw(in: rect)
            resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
        } else {
            print("Nil image.")
        }
        return resizedImage
    }
    
    func setTableActicityIndicator(tv: UITableView, isTop: Bool) {
        let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        spinner.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            spinner.stopAnimating()
            spinner.isHidden = true
        }
        spinner.frame = CGRect(x: 0, y: 0, width: tv.frame.width, height: 44)
        if (isTop) {
            tv.tableHeaderView = spinner
        } else {
            tv.tableFooterView = spinner
        }
    }
    
    
    static func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
}
