//
//  SLListVC.swift
//  OnTheMap
//
//  Created by Vitaliy Paliy on 10/21/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class SLListVC: UIViewController {
    
    var students = [StudentInformation]()
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var statusIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableStatus(true)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
        MapClient.getStudentInformation { (students, error) in
            self.students = students
            self.tableStatus(false)
            self.tableView.reloadData()
        }
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        
        MapClient.logout { (success, error) in
            if success{
                self.showLogout()
            }
        }
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "addNewLocation", sender: nil)
        
    }
}

extension SLListVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        
        let student = students[indexPath.row]
        
        cell.textLabel?.text = "\(student.firstName) \(student.lastName)"
        
        if student.mediaURL.starts(with: "http"){
            cell.detailTextLabel?.text = "⌲Link: \(student.mediaURL)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = students[indexPath.row]
        if UIApplication.shared.canOpenURL(URL(string: student.mediaURL)!){
            UIApplication.shared.open(URL(string: student.mediaURL)!)
        }else{
            showError("Error", "Incorrect URL")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableStatus(_ status: Bool){
        DispatchQueue.main.async {
            if status{
                self.statusIndicator.startAnimating()
            }else{
                self.statusIndicator.stopAnimating()
            }
            self.addButton.isEnabled = !status
            self.logoutButton.isEnabled = !status
            self.blurView.isHidden = !status
        }
    }
    
}
