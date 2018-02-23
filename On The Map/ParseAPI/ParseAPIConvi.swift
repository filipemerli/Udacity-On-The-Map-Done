//
//  ParseAPIConvi.swift
//  On The Map
//
//  Created by Filipe Merli on 20/02/2018.
//  Copyright © 2018 Filipe Merli. All rights reserved.
//

import Foundation
import UIKit

extension ParseAPIClient {
    
    func finishNewPin(firstTimeHere: Bool, completionHandlerForFinish: @escaping(_ success: Bool, _ errorString: String?) -> Void) {
        if firstTimeHere {
            taskForPostMethod() { (result, error) in
                if error == nil {
                    completionHandlerForFinish(true, nil)
                }else {
                    completionHandlerForFinish(false, "Failed on Post new location")
                }
            }
        } else {
            taskForPutMethod() { (result, error) in
                if error == nil {
                    completionHandlerForFinish(true, nil)
                } else {
                    completionHandlerForFinish(false, "Failed on Put new location")
                }
            }
        }
        
    }
    
    
}
