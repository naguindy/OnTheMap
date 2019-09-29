//
//  LocationManager.swift
//  OnTheMap
//
//  Created by Noha on 30.09.19.
//  Copyright © 2019 udacity. All rights reserved.
//

import Foundation
import CoreLocation

enum LocationError: Error {
    case generic
    case placemarkNotFound
    case invalidLocation


}

class LocationManager : NSObject{
    func getLocation(forPlaceCalled name: String, completion: @escaping(Result<CLLocation, LocationError>)-> Void){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(name) {(placemarks, error) in
            guard error == nil else{
                completion(.failure(.generic))
                return
            }
            guard let placemark = placemarks?.first else{
                completion(.failure(.placemarkNotFound))
                return
            }
            guard let location = placemark.location else{
                print("placemark location is nil")
                completion(.failure(.invalidLocation))
                return
            }
            
            completion(.success(location))
        }
    }
}
