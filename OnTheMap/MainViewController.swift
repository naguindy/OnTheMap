//
//  MainViewController.swift
//  OnTheMap
//
//  Created by Noha on 28.09.19.
//  Copyright © 2019 udacity. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        APIRequests.loadStudentsInformation { (students, error) in
            if let error = error {
                // Show Error
            }
            guard let students = students else { return }
            
            guard let listVC = self.viewControllers?[0] as? ListTableViewController else { return }
            listVC.students = students
        }
        
    }
    
    func studentInformationLoaded(students: [StudentInformation]?, error: Error?) {
        
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
