//
//  ConfirmedLocationViewController.swift
//  OnTheMap
//
//  Created by Noha on 27.09.19.
//  Copyright © 2019 udacity. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
class ConfirmedLocationViewController : UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var locationActivityIndicator: UIActivityIndicatorView!
    var annotation = MKPointAnnotation()
   var passedLocation : String?
   var passedURL: String?
   @IBOutlet weak var locationMapView: MKMapView!
   
    @IBOutlet weak var finishActivityIndicator: UIActivityIndicatorView!
    private let locationManager = LocationManager()
    var longitude = 0.0
    var latitude = 0.0
   var firstName = "Noha"
   var lastName = "Ayman"
   
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        locationActivityIndicator.startAnimating()
        API.instance.getStudent {[weak self] result in
            self?.locationActivityIndicator.stopAnimating()
            switch result {
                case .failure(let error):
                    self?.showError(error)
                case .success(let name):
                    self?.firstName = name.firstName
                    self?.lastName = name.lastName
            }
        }
        self.setMapLocation()
        
    }
    
    
    func setMapLocation() {
        
        let studentLocation = self.passedLocation!
        //"Champ de Mars, 5 Avenue Anatole France, 75007 Paris, France"
        
        self.locationManager.getLocation(forPlaceCalled: studentLocation) {[weak self] result in
            guard let self = self else { return }

            switch result {
                case .failure(let error):
                    self.showError(error)
                case .success(let location):
                    let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                    self.locationMapView.setRegion(region, animated: true)
                    self.latitude = location.coordinate.latitude
                    self.longitude = location.coordinate.longitude

                    self.annotation.coordinate = center
                    self.annotation.title = "\(self.firstName) \(self.lastName)"
                    self.annotation.subtitle = self.passedURL

                    self.locationMapView.addAnnotation(self.annotation)
                    self.locationMapView.delegate = self
            }
        }
    }

    func showError(_ error: LocationError) {
        //TODO: Show location manager error
        let controller = UIAlertController()
        controller.title = "Alert!"
        controller.message = "\(error)"

        let okAction = UIAlertAction(title: "ok", style: UIAlertAction.Style.default) { action in self.dismiss(animated: true, completion: nil)
        }

        controller.addAction(okAction)
        self.present(controller, animated: true, completion: nil)

    }

    func showError(_ error: APIError) {
        let controller = UIAlertController()
        controller.title = "Alert!"
        controller.message = "\(error.message)"

        let okAction = UIAlertAction(title: "ok", style: UIAlertAction.Style.default) { action in self.dismiss(animated: true, completion: nil)
        }

        controller.addAction(okAction)
        self.present(controller, animated: true, completion: nil)
  
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.image = #imageLiteral(resourceName: "icon_pin")
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView!
    }
    
    @IBAction func finish() {
        finishActivityIndicator.startAnimating()
        API.instance.postStundentLocation(firstName: firstName, lastName: lastName, mapString: passedLocation!, latitude: latitude, longitude: longitude, urlString: passedURL!){[weak self] result in
            self?.finishActivityIndicator.stopAnimating()
            switch result{
                case.failure(let error):
                    self?.showError(error)
                case .success:
                    self?.parent?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
