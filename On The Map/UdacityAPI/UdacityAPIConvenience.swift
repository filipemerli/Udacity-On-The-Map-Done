//
//  UdacityAPIConvenience.swift
//  On The Map
//
//  Created by Filipe Merli on 26/01/2018.
//  Copyright © 2018 Filipe Merli. All rights reserved.
//

import UIKit
import Foundation

// MARK: - UdacityAPICliente Convenient Resource Methods

extension UdacityAPIClient {
    
    func authenticateLogin(login: String, password: String, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        taskForPostMethod(user: login, password: password) { (result, error) in
            if (error == nil) {
                if let accountInfo = result!["account"] as? [String: AnyObject]! {
                    if accountInfo["registered"] as? Bool == true {
                        self.isRegistered = true
                    } else {
                        completionHandlerForAuth(false, "No registered information")
                    }
                    if let userKey = accountInfo["key"] as? String {
                        self.userKeyAPIClient = userKey
                        Student.shared.userKey = userKey
                        self.taskForDeleteMethod() { (success, error) in
                            if success! {
                                self.taskForGetUserInfo(userKey: self.userKeyAPIClient) { (result, error) in
                                    if (error == nil) {
                                        if let userInformation = result!["user"] as? [String: AnyObject]! {
                                            if let nickName = userInformation["nickname"] as? String {
                                                Student.shared.firstName = nickName
                                                completionHandlerForAuth(true, nil)
                                            } else {
                                                completionHandlerForAuth(false, "No name information")
                                            }
                                            
                                        } else {
                                            completionHandlerForAuth(false, "No user info information")
                                        }
                                    } else {
                                        completionHandlerForAuth(false, "No user info returned from server")
                                    }
                                }
                            } else {
                                completionHandlerForAuth(false, error?.domain)
                            }
                        }
                        
                    } else {
                        completionHandlerForAuth(false, "No Key information")
                    }
                } else {
                    completionHandlerForAuth(false, "Account Info not found")
                }
            } else {
                completionHandlerForAuth(false, "\(error?.domain ?? "Unknown error")")
            }
        }
    }
    
}
