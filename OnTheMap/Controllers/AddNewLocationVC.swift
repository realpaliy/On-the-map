//
//  AddNewLocationVC.swift
//  OnTheMap
//
//  Created by Vitaliy Paliy on 10/17/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import MapKit

class AddNewLocationVC: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var statusIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchButton: ButtonVC!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var urlText: UITextField!
    @IBOutlet weak var locationTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlText.delegate = self
        locationTF.delegate = self
    }
    
    let annotation = MKPointAnnotation()
    var firstName = ""
    var lastName = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        subscribeToKeyboardNotificationsWillHide()
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        MapClient.getUserPublicInfo { (data, error) in
            if let data = data {
                self.firstName = data.firstName
                self.lastName = data.lastName
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        self.searchStatus(true)
        checkTF()
        let location = locationTF.text!
        let name = "\(firstName) \(lastName)"
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placerMark, error) in
            if error != nil {
                self.showError("Erorr", "Error happened while tried to find a location")
                self.searchStatus(false)
            }else{
                if let mark = placerMark?[0]{
                    self.annotation.coordinate = (mark.location?.coordinate)!
                    self.annotation.title = name
                    let newLoc = StudentInformation(createdAt: "", firstName: self.firstName, lastName: self.lastName, latitude: mark.location!.coordinate.latitude, longitude: mark.location!.coordinate.longitude, mapString: location, mediaURL: self.urlText.text!, objectId: "PostedLocation.postedLocation.objectId", uniqueKey: MapClient.Auth.accountId, updatedAt: "")
                    self.goToController(loc: newLoc, annot: self.annotation)
                }
            }
        }
        
    }
    
    
    func goToController(loc: StudentInformation, annot: MKAnnotation){
        let controller = storyboard?.instantiateViewController(identifier: "NewLocationVC") as! NewLocationMapVC
        controller.newLocation = loc
        controller.location = annotation
        self.searchStatus(false)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    func checkTF() {
        
        if locationTF.text!.isEmpty{
            showError("Error","Enter location")
            searchStatus(false)
        }else if urlText.text!.isEmpty || !UIApplication.shared.canOpenURL(URL(string: urlText.text!)!){
            showError("Error","Enter correct URL")
            searchStatus(false)
        }
        
    }
    
    func searchStatus(_ status: Bool){
        DispatchQueue.main.async {
            if status{
                self.statusIndicator.startAnimating()
            }else{
                self.statusIndicator.stopAnimating()
            }
            self.searchButton.isEnabled = !status
            self.locationTF.isEnabled = !status
            self.urlText.isEnabled = !status
            self.cancelButton.isEnabled = !status
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
        if urlText.isEditing{
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
}
