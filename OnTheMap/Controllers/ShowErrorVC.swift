//
//  ShowErrorVC.swift
//  OnTheMap
//
//  Created by Vitaliy Paliy on 10/19/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

extension UITableViewController{
    
    func showURLError(_ message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert,animated: true)
    }
    
}

extension UIViewController{
    func showError(_ message: String){
        
    }
}
