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

    @IBOutlet weak var urlText: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var locationTF: UITextField!
    
    let annotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        checkTF()
        let location = locationTF.text!
        let name = "\(firstNameTF.text!) \(lastNameTF.text!)"
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placerMark, error) in
            if let mark = placerMark?[0]{
                self.annotation.coordinate = (mark.location?.coordinate)!
                self.annotation.title = name
                let newLoc = StudentInformation(createdAt: "", firstName: self.firstNameTF.text!, lastName: self.lastNameTF.text!, latitude: mark.location!.coordinate.latitude, longitude: mark.location!.coordinate.longitude, mapString: location, mediaURL: self.urlText.text!, objectId: "PostedLocation.postedLocation.objectId", uniqueKey: MapClient.Auth.accountId, updatedAt: "")
                self.goToController(loc: newLoc, annot: self.annotation)
            }
        }
        
    }
    
    
    func goToController(loc: StudentInformation, annot: MKAnnotation){
        let controller = storyboard?.instantiateViewController(identifier: "NewLocationVC") as! NewLocationMapVC
        controller.newLocation = loc
        controller.location = annotation
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
    
        dismiss(animated: true, completion: nil)
    
    }
    
    func checkTF(){
        if firstNameTF.text!.isEmpty{
            showError("Error","Enter your first name")
        }else if lastNameTF.text!.isEmpty{
            showError("Error","Enter your last name")
        }else if locationTF.text!.isEmpty{
            showError("Error","Enter location")
        }else if urlText.text!.isEmpty{
            showError("Error","Enter your URL")
        }
    }
    
}
