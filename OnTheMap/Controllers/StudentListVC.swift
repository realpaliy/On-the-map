//
//  StudentListVC.swift
//  OnTheMap
//
//  Created by Vitaliy Paliy on 10/19/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class StudentListVC: UITableViewController {

    var students = [StudentInformation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MapClient.getStudentInformation { (students, error) in
            self.students = students
            self.tableView.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        
        let student = students[indexPath.row]
        
        cell.textLabel?.text = "\(student.firstName) \(student.lastName)"
        
        if student.mediaURL.starts(with: "http"){
            cell.detailTextLabel?.text = "⌲Link: \(student.mediaURL)"
        }else{
            cell.detailTextLabel?.text = "⌲Link: Not Available"
        }
                
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = students[indexPath.row]
        if UIApplication.shared.canOpenURL(URL(string: student.mediaURL)!){
            UIApplication.shared.open(URL(string: student.mediaURL)!)
        }else{
            showURLError("Incorrect URL")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
    
        performSegue(withIdentifier: "addNewLocation", sender: nil)
        
    }
    
    
    @IBAction func logoutPressed(_ sender: Any) {
    
        MapClient.logout { (success, error) in
            if success{
                self.showLogout()
            }
        }
    
    }
    
}
