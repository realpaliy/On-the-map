//
//  LoginVC.swift
//  OnTheMap
//
//  Created by Vitaliy Paliy on 10/16/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var loginButton: ButtonVC!
    @IBOutlet weak var signUpButton: ButtonVC!
    @IBOutlet weak var statusIndicator: UIActivityIndicatorView!
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
        loginStatus(true)
        MapClient.login(username: self.usernameTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: self.loginHandler(success:error:))
    }
    
    func loginHandler(success: Bool, error: Error?){
        if success{
            print(MapClient.Auth.accountId)
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "loginComplete", sender: nil)
            }
        }else{
            showError("Login Failed",error?.localizedDescription ?? "")
            self.loginStatus(false)
        }
        
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com/authenticated")!)
    }
    
    func loginStatus(_ status: Bool){
        DispatchQueue.main.async {
            if status{
                self.statusIndicator.startAnimating()
            }else{
                self.statusIndicator.stopAnimating()
            }
            self.passwordTextField.isEnabled = !status
            self.usernameTextField.isEnabled = !status
            self.loginButton.isEnabled = !status
            self.signUpButton.isEnabled = !status
        }
    }
    
}
