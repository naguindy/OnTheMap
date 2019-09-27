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
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func getLoggedIN(_ sender: UIButton) {
        
        //performSegue(withIdentifier: "loginSegue", sender: self)
        
        var url = URL(string: "https://onthemap-api.udacity.com/v1/session")
        var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = """
                {"udacity":
                    {
                        "username": "\( self.emailTextField.text ?? "")",
                        "password": "\(self.passwordTextField.text ?? "")"
                    }
                }
""".data(using: .utf8)
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
