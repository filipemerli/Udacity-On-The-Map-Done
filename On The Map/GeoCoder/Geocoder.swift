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
    
    func getUserLocation(address: String, completionHandler: @escaping(_ result: Bool?,_ error: Error?) -> Void) {
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) -> Void in
        
            if((error) != nil){
                completionHandler(false, error)
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                Student.shared.latitude = coordinates.latitude
                Student.shared.longitude = coordinates.longitude
                completionHandler(true, nil)
            }
        })
    }
    
    
}
