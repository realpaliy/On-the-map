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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
            MapClient.login(username: self.usernameTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: self.loginHandler(success:error:))
    }

    func loginHandler(success: Bool, error: Error?){
        
        if success{
            print(MapClient.Auth.sessionId)
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "loginComplete", sender: nil)
                MapClient.updateUser { (response, error) in
                    if let response = response {
                        print(response)
                    }
                }
            }
        }else{
            showError("Login Failed",error?.localizedDescription ?? "")
        }
    
    }
    
    @IBAction func signUpButton(_ sender: Any) {
    
        UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com/authenticated")!)
    
    }
}
