//
//  TableViewController.swift
//  On The Map
//
//  Created by Filipe Merli on 27/01/2018.
//  Copyright © 2018 Filipe Merli. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var student = StudentLoc.shared
    
    @IBAction func tableViewLogout(_ sender: Any) {
        logoutConfirm()
    }
    @IBOutlet weak var studentTableView: UITableView!

    @IBAction func listViewRefresh(_ sender: Any) {
        
        populateTable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        populateTable()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToUrl(link: student[indexPath.row].mediaUrl)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return student.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellReuseIdentifier = "pinListCell"
        let students = student[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        cell?.textLabel?.text = "\(students.firstName ?? "No") \(students.lastName ?? "Name")"
        cell?.detailTextLabel?.text = students.mediaUrl
        cell?.imageView?.image = #imageLiteral(resourceName: "icon_pin")
        cell?.imageView?.contentMode = UIViewContentMode.scaleAspectFill

        return cell!
    }
    
    func populateTable() {
        let spinner = TableViewController.displaySpinner(onView: self.view)
        ParseAPIClient.sharedInstance().taskForGetMethod { (student, error) in
            if let student = student {
                self.student = student as! [StudentLoc]
                performUIUpdatesOnMain {
                    self.studentTableView.reloadData()
                    TableViewController.removeSpinner(spinner: spinner)
                }
            } else {
                TableViewController.removeSpinner(spinner: spinner)
                print(error ?? "empty error")
            }
        }
    }


}
