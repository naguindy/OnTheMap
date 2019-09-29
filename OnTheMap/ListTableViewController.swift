//
//  ListTableViewController.swift
//  OnTheMap
//
//  Created by Noha on 28.09.19.
//  Copyright © 2019 udacity. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {

    var students: [StudentInformation] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "student-cell", for: indexPath)
         let student = students[indexPath.row]
         cell.textLabel?.text = student.firstName + "" + student.lastName
         cell.detailTextLabel?.text = student.mediaURL
        return cell

    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = students[indexPath.row]
        guard let url = URL(string: student.mediaURL) else {
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

}
