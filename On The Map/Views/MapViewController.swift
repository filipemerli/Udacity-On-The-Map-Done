//
//  MapViewController.swift
//  On The Map
//
//  Created by Filipe Merli on 29/01/2018.
//  Copyright © 2018 Filipe Merli. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var students = StudentLoc.shared
    
    @IBAction func mapViewLogout(_ sender: Any) {
        logoutConfirm()
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func mapViewRefresh(_ sender: Any) {
        populateMap()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        populateMap()
        
    }

    func placeThesePins () {
        
        mapView.removeAnnotations(mapView.annotations)
        
        var annotations = [MKPointAnnotation]()
        
        for singlePin in students {
            let lat = CLLocationDegrees(singlePin.latitude!)
            let lon = CLLocationDegrees(singlePin.longitude!)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            annotation.title = "\(singlePin.firstName ?? "No ")"+"\(singlePin.lastName ?? "Name")"
            annotation.subtitle = singlePin.mediaUrl
            
            annotations.append(annotation)
        }
        self.mapView.addAnnotations(annotations)
        
    }
    

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        if control == annotationView.rightCalloutAccessoryView {
            goToUrl(link: (annotationView.annotation?.subtitle)!)
            }
        }
    
    func populateMap() {
        let spinner = MapViewController.displaySpinner(onView: self.view)
        ParseAPIClient.sharedInstance().taskForGetMethod { (student, error) in
            if let student = student {
                self.students = student as! [StudentLoc]
                performUIUpdatesOnMain {
                    self.placeThesePins()
                    MapViewController.removeSpinner(spinner: spinner)
                }
            } else {
                MapViewController.removeSpinner(spinner: spinner)
                print(error ?? "Unknown error")
            }
        }
    }

}
