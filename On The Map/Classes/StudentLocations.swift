//
//  StudentLocations.swift
//  On The Map
//
//  Created by Filipe Merli on 24/01/2018.
//  Copyright © 2018 Filipe Merli. All rights reserved.
//

import Foundation

class StudentLoc {
    var objectId: String?
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
    var mapString: String?
    var mediaUrl: String?
    var latitude: Float?
    var longitude: Float?
    
    
    // MARK: Initializers
    
    init?(dictionary: [String:AnyObject]) {
        
        guard let latitude = dictionary["latitude"] as? Float, let longitude = dictionary["longitude"] as? Float else {
            return nil
        }
        
        self.latitude = latitude
        self.longitude = longitude
        objectId = dictionary["objectId"] as? String
        uniqueKey = dictionary["uniqueKey"] as? String
        firstName = dictionary["firstName"] as? String
        lastName = dictionary["lastName"] as? String
        mapString = dictionary["mapString"] as? String
        mediaUrl = dictionary["mediaURL"] as? String

    }
    
    static func locationsFromResults(_ results: [[String:AnyObject]]) -> [StudentLoc] {
        
        var locations = [StudentLoc]()
        for result in results {
            if let student = StudentLoc(dictionary: result) {
                locations.append(student)
            }
        }
        return locations
    }
    
    class var shared: [StudentLoc] {
        struct Static {
            static let instance: [StudentLoc] = [StudentLoc]()
        }
        return Static.instance
    }
    
    
}


