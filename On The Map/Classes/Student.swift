//
//  Student.swift
//  On The Map
//
//  Created by Filipe Merli on 11/01/2018.
//  Copyright © 2018 Filipe Merli. All rights reserved.
//

import Foundation

class Student {
    var email: String = ""
    var password: String = ""
    var userKey = ""
    var firstName = ""
    var lastName = ""
    var studentID = ""
    var latitude: Double?
    var longitude: Double?
    var url = ""
    var state = ""
    var city = ""
    var mapString = ""
    var objectId = ""
    var firstTimePosting: Bool?
    
    
    class var shared: Student {
        struct Static {
            static let instance: Student = Student()
        }
        return Static.instance
    }
    
    
}
