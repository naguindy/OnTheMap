//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Noha on 28.09.19.
//  Copyright © 2019 udacity. All rights reserved.
//

import Foundation
import CoreLocation

struct StudentInformation {
   // let uniqueKey: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    
    

    init(dictionary: [String: Any]) {
        firstName = dictionary["firstName"] as! String
        lastName = dictionary["lastName"] as! String
        latitude = dictionary["latitude"] as! Double
        longitude = dictionary["longitude"] as! Double
        mapString = dictionary["mapString"] as! String
        mediaURL = dictionary["mediaURL"] as! String
    }
}

