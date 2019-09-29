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
    static var studentKey = ""
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func getLoggedIN(_ sender: UIButton) {
        guard let email = emailTextField.text,
            !email.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty else {
            showMissingFieldError()
            return
        }

        spinner.startAnimating()
        API.instance.login(username: email, password: password) { [weak self] result in
            self?.spinner.stopAnimating()
            switch result {
                case .success:
                    self?.performSegue(withIdentifier: "loginSegue", sender: self)
                case .failure(let error):
                    self?.showLoginError(error)
            }
        }
    }
    
    
    func showLoginError(_ error: APIError) {
        // Show API request error message
        let controller = UIAlertController()
        controller.title = "Alert!"
        controller.message = "\(error.message)"

        let okAction = UIAlertAction(title: "ok", style: UIAlertAction.Style.default) { action in self.dismiss(animated: true, completion: nil)
        }

        controller.addAction(okAction)
        self.present(controller, animated: true, completion: nil)
        print(error.message)
    }

    func showMissingFieldError() {
        let controller = UIAlertController()
        controller.title = "Alert!"
        controller.message = "Missing username or password"

        let okAction = UIAlertAction(title: "ok", style: UIAlertAction.Style.default) { action in self.dismiss(animated: true, completion: nil)
        }

        controller.addAction(okAction)
        self.present(controller, animated: true, completion: nil)


        
    }
    
    @IBAction func signUp(_ sender: Any) {
        if let url = URL(string: "http://www.udacity.com"){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
