//
//  LoginVC.swift
//  OnTheMap
//
//  Created by Vitaliy Paliy on 10/16/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
            MapClient.login(username: self.usernameTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: self.loginHandler(success:error:))
    }

    func loginHandler(success: Bool, error: Error?){
        
        if success{
            print(MapClient.Auth.sessionId)
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "loginComplete", sender: nil)
            }
        }
    
    }
    
}
