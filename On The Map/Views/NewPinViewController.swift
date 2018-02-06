//
//  NewPinViewController.swift
//  On The Map
//
//  Created by Filipe Merli on 05/02/2018.
//  Copyright © 2018 Filipe Merli. All rights reserved.
//

import UIKit
import MapKit

class NewPinViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var newPinMap: MKMapView!
    
    @IBOutlet weak var finishButton: UIButton!
    
    @IBAction func finishPost(_ sender: Any) {
        performUIUpdatesOnMain {
            ParseAPIClient.sharedInstance().taskForPutMethod { result, error in
                if result == true {
                    print("Done!")
                    self.sendUIAlert(error: "DONE!")
                } else {
                    self.sendUIAlert(error: "FAILED :(")
                }
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newPinMap.delegate = self
        
        zoomOnMap()


    }

    @IBAction func cancelPostNewPin(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    
    func zoomOnMap() {
        var zoomLocation = CLLocationCoordinate2D()
        zoomLocation.latitude = Student.shared.latitude!
        zoomLocation.longitude = Student.shared.longitude!
        let viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 200, 200)
        newPinMap.setRegion(viewRegion, animated: false)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = zoomLocation.latitude
        annotation.coordinate.longitude = zoomLocation.longitude
        
        annotation.title = "\(Student.shared.firstName) "+"\(Student.shared.lastName)"
        annotation.subtitle = Student.shared.url
        
        self.newPinMap.addAnnotation(annotation)
    }
    
}


