//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Noha on 27.09.19.
//  Copyright © 2019 udacity. All rights reserved.
//

import Foundation
import UIKit
class AddLocationViewController : UIViewController {
    
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var URLTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var cancelPost: UIBarButtonItem!
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocation(_ sender: UIButton) {
        
       performSegue(withIdentifier: "confirmSegue", sender: self)
  }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirmSegue" {
            let nextController = segue.destination as! ConfirmedLocationViewController
            nextController.passedLocation = self.locationTextField.text
            nextController.passedURL = self.URLTextField.text
            
        }
    }
    
}
