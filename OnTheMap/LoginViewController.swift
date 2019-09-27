//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Noha on 27.09.19.
//  Copyright © 2019 udacity. All rights reserved.
//

import Foundation
import UIKit
class LoginViewController : UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func getLoggedIN(_ sender: UIButton) {
        
        performSegue(withIdentifier: "loginSegue", sender: self)
    }
}
