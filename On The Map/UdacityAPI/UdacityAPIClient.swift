//
//  UdacityAPIClient.swift
//  On The Map
//
//  Created by Filipe Merli on 15/01/2018.
//  Copyright © 2018 Filipe Merli. All rights reserved.
//

import UIKit


class UdacityAPIClient: NSObject {
    
    // MARK: Properties
    
    var session = URLSession.shared
    var userKeyAPIClient = ""
    var isRegistered: Bool?
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: POST
    
    func taskForPostMethod(user: String, password: String, completionHandlerForPost : @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        var request = URLRequest(url: URL(string: "\(UdacityAPIConstants.url)")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(user)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
                func sendError(_ error: String) {
                    let userInfo = [NSLocalizedDescriptionKey : error]
                    completionHandlerForPost(nil, NSError(domain: error, code: 1, userInfo: userInfo))
                }
                guard (error == nil) else {
                    sendError("There was an error with your Login information")
                    return
                }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                let httpError = (response as? HTTPURLResponse)?.statusCode
                if httpError == 403 {
                    sendError("Invalid Email or Password")
                } else {
                    sendError("The request returned status code: \(String(describing: httpError))")
                }
                return
            }
            guard let data = data else {
                sendError("No data returned")
                return
            }

            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPost)
        }
        task.resume()
    }
    
    
    func taskForDeleteMethod(completionHandlerForDelete: @escaping(_ result: Bool?, _ error: NSError?) -> Void){
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForDelete(true, NSError(domain: "taskForPostMethod", code: 1, userInfo: userInfo))
            }
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range)
            self.convertDataWithCompletionHandler(newData!) { parsedResult, error in
                if error == nil {
                    completionHandlerForDelete(true, nil)
                }else {
                    sendError("There was an error with your request: \(error!)")
                }
            }
        }
        task.resume()
    }
    
    func taskForGetUserInfo(userKey: String, completionHandlerForGetInfo: @escaping(_ result:AnyObject?, _ error: NSError?)-> Void){
        let request = URLRequest(url: URL(string: "https://www.udacity.com/api/users/\(userKey)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGetInfo(nil, NSError(domain: "taskForPostMethod", code: 1, userInfo: userInfo))
            }
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range)
            self.convertDataWithCompletionHandler(newData!) { parsedResult, error in
                if error == nil {
                completionHandlerForGetInfo(parsedResult, nil)
                } else {
                    completionHandlerForGetInfo(nil, error)
                }
            }
        }
        task.resume()
    }
    
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> UdacityAPIClient{
        struct Singleton{
            static var sharedInstance = UdacityAPIClient()
        }
        return Singleton.sharedInstance
    }
    
}
