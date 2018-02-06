//
//  ParseAPIClient.swift
//  On The Map
//
//  Created by Filipe Merli on 24/01/2018.
//  Copyright © 2018 Filipe Merli. All rights reserved.
//

import UIKit

class ParseAPIClient: NSObject {
    
    // MARK: Properties
    
    var session = URLSession.shared
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: GET
    
    func taskForGetMethod(completionHandlerForGetMethod: @escaping(_ result: AnyObject?, _ error: Error?)-> Void) {
        var request = URLRequest(url: URL(string: "\(ParseConstants.parseUrl)\(ParseConstants.getMethodLimit)\(ParseConstants.oderListAtoZ)")!)
        request.addValue("\(ParseConstants.appID)", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("\(ParseConstants.apiKey)", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completionHandlerForGetMethod(nil, error)
                return
            }
            self.convertDataWithCompletionHandler(data!) { results, error in
                if let error = error {
                    completionHandlerForGetMethod(nil, error)
                } else {
                    if let results = results?["results"] as? [[String:AnyObject]] {
                        
                        let locations = StudentLoc.locationsFromResults(results)
                        completionHandlerForGetMethod(locations as AnyObject, nil)
                    } else {
                        completionHandlerForGetMethod(nil, NSError(domain: "getParseAPI parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse locations"]))
                    }
                }
            }
        }
        task.resume()
    }
    
    func taskForGetSingleMethod(completionHandlerForGetSingle: @escaping(_ result: AnyObject?,_ error: Error?) -> Void) {
        var request = URLRequest(url: URL(string: "\(ParseConstants.parseUrl)?where=%7B%22uniqueKey%22%3A%22\(Student.shared.userKey)%22%7D")!)
        request.addValue("\(ParseConstants.appID)", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("\(ParseConstants.apiKey)", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard error ==  nil else {
                completionHandlerForGetSingle(nil, error)
                return
            }
            self.convertDataWithCompletionHandler(data!) { results, error in
                
                completionHandlerForGetSingle(results, error)
                //print(results)
            }
        }
        task.resume()
    }
    
    
    func taskForPutMethod(completionHandlerForPut: @ escaping(_ result: Bool?,_ error: Error?) -> Void) {
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/8ZExGR5uX8"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue("\(ParseConstants.appID)", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("\(ParseConstants.apiKey)", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(Student.shared.userKey)\", \"firstName\": \"\(Student.shared.firstName)\", \"lastName\": \"\",\"mapString\": \"\(Student.shared.mapString)\", \"mediaURL\": \"\(Student.shared.url)\",\"latitude\": \(Student.shared.latitude), \"longitude\": \(Student.shared.longitude)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completionHandlerForPut(false, error)
                return
            }
            completionHandlerForPut(true, nil)
        }
        task.resume()
    }
    
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
    class func sharedInstance() -> ParseAPIClient{
        struct Singleton{
            static var sharedInstance = ParseAPIClient()
        }
        return Singleton.sharedInstance
    }
    
    
}
