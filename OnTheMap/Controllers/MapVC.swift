//
//  MapVC.swift
//  OnTheMap
//
//  Created by Vitaliy Paliy on 10/17/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, MKMapViewDelegate {

    var annotations = [MKPointAnnotation]()
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var statusIndicator: UIActivityIndicatorView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        if StudentLocationModel.studentLocations.isEmpty{
            mapStatus(true)
            getLocation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
        mapStatus(true)
        getLocation()
    }
    
    func getLocation(){
        MapClient.getStudentInformation(completion: handleStudentLocationResponse(locations:error:))
    }

    func handleStudentLocationResponse(locations: [StudentInformation], error: Error?){
        if !locations.isEmpty{
            for dictionary in locations{
                let lat = CLLocationDegrees(dictionary.latitude as Double)
                let long = CLLocationDegrees(dictionary.longitude as Double)
                
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let first = dictionary.firstName
                let last = dictionary.lastName
                let mediaURL = dictionary.mediaURL
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
                
                annotations.append(annotation)
                blurView.isHidden = true
                mapStatus(false)
            }
            self.mapView.addAnnotations(annotations)
        }else{
            showError("Error", "Error happened while downloading data")
            mapStatus(false)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil{
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }else{
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView{
            if let toOpen = view.annotation?.subtitle!{
                UIApplication.shared.open(URL(string: toOpen)!)
            }
        }
    }
    
    @IBAction func mapPinPressed(_ sender: Any) {
        performSegue(withIdentifier: "addNewLocation", sender: nil)
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
    
        MapClient.logout { (success, error) in
            if success{
                self.showLogout()
            }
        }
        
    }
    
    func mapStatus(_ status: Bool){
        DispatchQueue.main.async {
            if status{
                self.statusIndicator.startAnimating()
            }else{
                self.statusIndicator.stopAnimating()
            }
            self.addButton.isEnabled = !status
            self.logoutButton.isEnabled = !status
        }
    }
    
}
