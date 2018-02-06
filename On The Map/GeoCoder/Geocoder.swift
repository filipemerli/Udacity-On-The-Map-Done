//
//  Geocoder.swift
//  On The Map
//
//  Created by Filipe Merli on 01/02/2018.
//  Copyright © 2018 Filipe Merli. All rights reserved.
//

import Foundation
import CoreLocation

extension PostingViewController {
    
    func getUserLocation(completionHandler: @escaping (CLPlacemark?) -> Void) {
        
        let geocoder = CLGeocoder()
        
        let locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        let currentLoc: CLLocation!
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways) {
            
            currentLoc = locManager.location
            Student.shared.latitude = currentLoc.coordinate.latitude 
            Student.shared.longitude = currentLoc.coordinate.longitude
            
            let location = CLLocation(latitude: Student.shared.latitude!, longitude: Student.shared.longitude!)
            geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                completionHandler(placeMark)
            })
            
            
        } else {
            completionHandler(nil)
        }
        
    }
    
    
}
