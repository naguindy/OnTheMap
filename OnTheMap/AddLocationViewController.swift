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
    
    @IBOutlet weak var cancelPost: UIBarButtonItem!
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func findLocation(_ sender: UIButton) {
        performSegue(withIdentifier: "confirmSegue", sender: self)
    }
}
