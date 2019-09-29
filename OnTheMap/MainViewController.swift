//
//  MainViewController.swift
//  OnTheMap
//
//  Created by Noha on 28.09.19.
//  Copyright © 2019 udacity. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    @IBOutlet weak var logout: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadStudents()
    }
    
    func loadStudents(){
        API.instance.loadStudentInformation {[weak self] result in
            switch result {
                case .failure(let error):
                    self?.showError(error)
                case .success(let students):
                    guard let listVC = self?.viewControllers?[0] as? ListTableViewController else { return }
                    listVC.students = students
                    guard let mapVC = self?.viewControllers?[1] as? MapViewController else{return}
                    mapVC.students = students
            }
        }
    }

    func showError(_ error: APIError) {
        let controller = UIAlertController()
        controller.title = "Error!"
        controller.message = "\(error.message)"

        let okAction = UIAlertAction(title: "ok", style: UIAlertAction.Style.default) { action in self.dismiss(animated: true, completion: nil)
        }

        controller.addAction(okAction)
        self.present(controller, animated: true, completion: nil)
        
    }

    @IBAction func reloadStudentsList(_ sender: Any) {
        loadStudents()
    }
    
    @IBAction func logout(_ sender: Any) {
        API.instance.logout { [weak self] result in
            switch result {
                case .success:
                    if let navigationController = self?.navigationController{
                        navigationController.popToRootViewController(animated: false)
                    }
                case .failure(let error):
                    self?.showError(error)
            }
        }
    }
}
