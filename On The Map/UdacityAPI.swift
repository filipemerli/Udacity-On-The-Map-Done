//
//  UdacityAPI.swift
//  On The Map
//
//  Created by Filipe Merli on 15/01/2018.
//  Copyright © 2018 Filipe Merli. All rights reserved.
//

import Foundation
class UdacityAPIClient: NSObject{
    var session = URLSession.shared
    
    func taskForPostmethod( username: String, password: String, completionHandlerForPost : @escaping (_ result: AnyObject?, _ error: String?) -> Void){
    var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
        if error != nil { // Handle error…
            return
        }
        let range = Range(5..<data!.count)
        let newData = data?.subdata(in: range) /* subset response data! */
        print(String(data: newData!, encoding: .utf8)!)
    }
    task.resume()
    }
    
}
