//
//  UsersTableViewController.swift
//  Lost_Find
//
//  Created by Gajula,Vineeth on 4/3/17.
//  Copyright © 2017 nwmsu. All rights reserved.
//

import UIKit

// Lists all the users who found items after the search
class UsersTableViewController: UITableViewController {

    var emails = [String]()
    var objectIDs = [String]()
    var product_name = ""
    
    @IBOutlet var mytableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.emails.count
    }
    
    // each cell contains User's email and product name
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "users", for: indexPath)
        cell.detailTextLabel?.text = self.emails[indexPath.row]
        cell.textLabel?.text = self.product_name
        return cell
    }
    
    // selecting a cell directs to ResultsFoundTableViewController.This method sends object id and email of the selected cell to that view controller.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let resultsVC = self.storyboard?.instantiateViewController(withIdentifier: "ResultsFoundTableVC") as! ResultsFoundTableViewController
        self.navigationController?.pushViewController(resultsVC, animated: true)
        resultsVC.objID = self.objectIDs[indexPath.row]
        resultsVC.email = self.emails[indexPath.row]
    }
}
