//
//  ShowErrorVC.swift
//  OnTheMap
//
//  Created by Vitaliy Paliy on 10/19/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

extension UIViewController{
    
    func showError(_ title: String,_ message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert,animated: true)
        }
    }
    
    func showLogout(){
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                   DispatchQueue.main.async {
                       self.dismiss(animated: true, completion: nil)
                   }
               }))
        DispatchQueue.main.async {
            self.present(alert,animated: true)
        }
    }
    
}


