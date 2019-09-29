//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Noha on 29.09.19.
//  Copyright © 2019 udacity. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapSpinner: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    var students: [StudentInformation] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        mapSpinner.startAnimating()
        var annotations = [MKPointAnnotation]()
        
        for student in students{
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let first = student.firstName
            let last = student.lastName
            let mediaURL = student.mediaURL
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            annotations.append(annotation)
        }
        self.mapView.addAnnotations(annotations)
        
        self.mapView.delegate = self
        self.mapSpinner.stopAnimating()
        // Do any additional setup after loading the view.
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl){
        guard control == view.rightCalloutAccessoryView else { return }


        let link = view.annotation?.subtitle! ?? ""

        guard let url = URL(string: link) else {
            showError(message: "Invalid URL")
            return
        }

        guard UIApplication.shared.canOpenURL(url) else {
            showError(message: "Can't open URL")
            return
        }

        UIApplication.shared.open(url, completionHandler: nil)
    }

    func showError(message: String) {

    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
