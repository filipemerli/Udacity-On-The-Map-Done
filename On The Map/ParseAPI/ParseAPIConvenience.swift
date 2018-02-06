//
//  ParseAPIConvenience.swift
//  On The Map
//
//  Created by Filipe Merli on 30/01/2018.
//  Copyright © 2018 Filipe Merli. All rights reserved.
//

import Foundation

extension ParseAPIClient {
    func populateStudents() {
        ParseAPIClient.sharedInstance().taskForGetMethod { (student, error) in
            if let student = student {
                self.student = student as! [StudentLoc]
                performUIUpdatesOnMain {
                    self.studentTableView.reloadData()
                }
            } else {
                print(error ?? "empty error")
            }
        }
    }
}
