//
//  AddNewLocationVC.swift
//  OnTheMap
//
//  Created by Vitaliy Paliy on 10/17/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import MapKit

class AddNewLocationVC: UIViewController {
    
    @IBOutlet weak var statusIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchButton: ButtonVC!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var urlText: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var locationTF: UITextField!
    
    let annotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        self.searchStatus(true)
        checkTF()
        let location = locationTF.text!
        let name = "\(firstNameTF.text!) \(lastNameTF.text!)"
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placerMark, error) in
            if error != nil {
                self.showError("Erorr", "Error happened while tried to find a location")
                self.searchStatus(false)
            }else{
                if let mark = placerMark?[0]{
                    self.annotation.coordinate = (mark.location?.coordinate)!
                    self.annotation.title = name
                    let newLoc = StudentInformation(createdAt: "", firstName: self.firstNameTF.text!, lastName: self.lastNameTF.text!, latitude: mark.location!.coordinate.latitude, longitude: mark.location!.coordinate.longitude, mapString: location, mediaURL: self.urlText.text!, objectId: "PostedLocation.postedLocation.objectId", uniqueKey: MapClient.Auth.accountId, updatedAt: "")
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
        if firstNameTF.text!.isEmpty{
            showError("Error","Enter your first name")
            searchStatus(false)
        }else if lastNameTF.text!.isEmpty{
            showError("Error","Enter your last name")
            searchStatus(false)
        }else if locationTF.text!.isEmpty{
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
            self.firstNameTF.isEnabled = !status
            self.lastNameTF.isEnabled = !status
            self.locationTF.isEnabled = !status
            self.urlText.isEnabled = !status
            self.cancelButton.isEnabled = !status
        }
    }
    
}
