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
    var newLocation: StudentInformation!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var postButton: ButtonVC!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var statusIndicator: UIActivityIndicatorView!
    
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
        self.searchStatus(true)
        MapClient.postStudentLocation(postData: newLocation) { (data, error) in
            if let data = data{
                self.newLocation.createdAt = data.createdAt
                self.newLocation.objectId = data.objectId
                self.searchStatus(false)
                self.navigationController?.popToRootViewController(animated: true)
            }else{
                self.searchStatus(false)
                self.showError("Error", "Error happened with adding new annotation")
            }
        }
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func searchStatus(_ status: Bool){
        DispatchQueue.main.async {
            if status{
                self.statusIndicator.startAnimating()
            }else{
                self.statusIndicator.stopAnimating()
            }
            self.postButton.isEnabled = !status
            self.cancelButton.isEnabled = !status
        }
    }
    
}
