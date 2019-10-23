//
//  LoginVC.swift
//  OnTheMap
//
//  Created by Vitaliy Paliy on 10/16/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var loginButton: ButtonVC!
    @IBOutlet weak var signUpButton: ButtonVC!
    @IBOutlet weak var statusIndicator: UIActivityIndicatorView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.delegate = self
        usernameTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usernameTextField.text = ""
        passwordTextField.text = ""
        subscribeToKeyboardNotifications()
        subscribeToKeyboardNotificationsWillHide()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        loginStatus(true)
        MapClient.login(username: self.usernameTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: self.loginHandler(success:error:))
    }
    
    func loginHandler(success: Bool, error: Error?){
        if success{
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
    
    func hideKeyboard(_ textField: UITextField){
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard(textField)
        return true
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func subscribeToKeyboardNotificationsWillHide() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        
        view.frame.origin.y = 0
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if passwordTextField.isEditing{
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
}
