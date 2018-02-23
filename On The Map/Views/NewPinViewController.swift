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
        let spinner = NewPinViewController.displaySpinner(onView: self.view)
        ParseAPIClient.sharedInstance().finishNewPin(firstTimeHere: Student.shared.firstTimePosting!) { (success, error) in
            guard error == nil else {
                performUIUpdatesOnMain {
                    NewPinViewController.removeSpinner(spinner: spinner)
                    self.displayFinalResult(result: error!)
                    self.dismiss(animated: true, completion: nil)
                }
                return
            }
            if success {
                performUIUpdatesOnMain {
                    NewPinViewController.removeSpinner(spinner: spinner)
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                performUIUpdatesOnMain {
                    NewPinViewController.removeSpinner(spinner: spinner)
                    self.displayFinalResult(result: "FAILED :(\nLooks like something went worg. You can try again!")
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
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
    
    func displayFinalResult(result: String) {
        let alertController = UIAlertController(title: "Message", message: result, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { action in
            alertController.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
        
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


