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

    @IBOutlet weak var locationTF: UITextField!
    let annotation = MKPointAnnotation()
    override func viewDidLoad() {
        super.viewDidLoad()
            
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        let location = locationTF.text!
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placerMark, error) in
            if let mark = placerMark?[0]{
                self.annotation.coordinate = (mark.location?.coordinate)!
                self.annotation.title = location
            }
        }
        
    }
    
    
}
