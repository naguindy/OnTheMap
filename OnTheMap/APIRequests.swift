//
//  APIRequests.swift
//  OnTheMap
//
//  Created by Noha on 27.09.19.
//  Copyright © 2019 udacity. All rights reserved.
//

import Foundation
import UIKit
class APIRequests: UIViewController {
     func udacitySession(){
    var url = URL(string: "https://onthemap-api.udacity.com/v1/session")
    var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"account@domain.com\", \"password\": \"********\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request){(data, response, error) in
            if error != nil {
                print("couldn't login, error \(error)")
            } else{
                let range = 5..<data!.count
                let newData = data?.subdata(in: range)
                print(String(data: newData!, encoding: .utf8)!)
            }
        }
        task.resume()
    }
}
