//
//  ConfirmedLocationViewController.swift
//  OnTheMap
//
//  Created by Noha on 27.09.19.
//  Copyright © 2019 udacity. All rights reserved.
//

import Foundation
import UIKit
class ConfirmedLocationViewController : UIViewController {
    
    @IBOutlet weak var finishButton: UIButton!
    
    @IBAction func finish() {
       performSegue(withIdentifier: "finishSegue", sender: self)
    }
}
