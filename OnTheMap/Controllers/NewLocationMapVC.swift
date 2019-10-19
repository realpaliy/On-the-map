//
//  NewLocationMapVC.swift
//  OnTheMap
//
//  Created by Vitaliy Paliy on 10/17/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import MapKit

class NewLocationMapVC: UIViewController, MKMapViewDelegate{

    var location: MKPointAnnotation!
    
    var selectedLocation: StudentInformation!
    
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let location = location{
            var region: MKCoordinateRegion = mapView.region
            region.center.latitude = location.coordinate.latitude
            region.center.longitude = location.coordinate.longitude
            region.span.latitudeDelta = 0.05
            region.span.longitudeDelta = 0.05
            mapView.setRegion(region, animated: true)
            mapView.addAnnotation(location)
        }
        
    }

    @IBAction func buttonPressed(_ sender: Any) {
    
        MapClient.postStudentLocation(postData: selectedLocation) { (success, error) in
            if success{
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
}
