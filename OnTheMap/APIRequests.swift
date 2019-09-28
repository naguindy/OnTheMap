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
    
    static func loadStudentsInformation(_ completion: @escaping ([StudentInformation]?, Error?) -> Void) {
     
        let url = URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request){(data, response, error) in
            
            guard let data = data else {
                return
            }
            
            guard let response = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: [[String: Any]]] else { return }
            
            guard let results = response["results"] else { return }
           
            var students: [StudentInformation] = []
            for item in results {
                let student = StudentInformation(
                    firstName: item["firstName"] as! String,
                    lastName: item["lastName"] as! String,
                    latitude: item["latitude"] as! Double,
                    longitude: item["longitude"] as! Double,
                    mapString: item["mapString"] as! String,
                    mediaURL: URL(string: item["mediaURL"] as! String))
                students.append(student)
            }
            
            DispatchQueue.main.async {
                completion(students, nil)                
            }
        }
        task.resume()
    }
}
