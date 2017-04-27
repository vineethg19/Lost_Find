//
//  TableViewController.swift
//  Lost? Find.
//
//  Created by Gajula,Vineeth on 2/28/17.
//  Copyright © 2017 Gajula,Vineeth. All rights reserved.
//

import UIKit
import Parse

// Lists all the items reported by the user under 2 sections "Lost" and "Found".
class TableViewController: UITableViewController {
    
    var lost_reports = [PFObject]()
    var found_reports = [PFObject]()
    var email = ""
    var objid = ""
    
    @IBOutlet var myTable: UITableView!
    
    // getting the email of currently logged-in user.
    override func viewDidLoad() {
        super.viewDidLoad()
        let username = PFUser.current()
        email = (username?.username)!
    }
    
    // reloading the table to see updated data.
    func loadList()
    {
        self.myTable.reloadData()
    }
    
    // loading the list each time as the view appears.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        self.myTable.reloadData()
        toQuery()
    }
    
    // querying the data and retrieving items which are lost and found.
    func toQuery()
    {
        let q1 = PFQuery(className: "report")
        q1.whereKey("email", equalTo: self.email)
        q1.whereKey("reported", equalTo: "Lost")
        q1.findObjectsInBackground { (results:[PFObject]?, error: Error?) in
            if let foundReports = results
            {
                self.lost_reports = foundReports
                self.myTable.reloadData()
            }
        }
        let q2 = PFQuery(className: "report")
        q2.whereKey("email", equalTo: self.email)
        q2.whereKey("reported", equalTo: "Found")
        q2.findObjectsInBackground { (results:[PFObject]?, error: Error?) in
            if let foundReports = results
            {
                self.found_reports = foundReports
                self.myTable.reloadData()
            }
        }
    }
    
    // 2 sections needed in the table
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // titles for the sections
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0
        {
            return "Lost"
        }
        else
        {
            return "Found"
        }
    }
    
    // rows for the sections
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return lost_reports.count
        }
        else
        {
            return found_reports.count
        }
    }
    
    // value for the row which is fetched by querying from the database and displaying them in the table cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0
        {let cell = tableView.dequeueReusableCell(withIdentifier: "Lost")
            let u:PFObject = lost_reports[indexPath.row]
            cell?.textLabel!.text = u.object(forKey: "pname") as? String
            return cell!
            
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Found")
            let u:PFObject = found_reports[indexPath.row]
            cell?.textLabel!.text = u.object(forKey: "pname") as? String
            
            return cell!
        }
    }
    
    // unwinding segue
    @IBAction func unwindtoTBVC(segue: UIStoryboardSegue)
    {
        self.myTable.reloadData()
    }
    
    // selecting a cell causes to pass data about the cell to itemViewController
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemVC = self.storyboard?.instantiateViewController(withIdentifier: "ItemViewController") as! ItemViewController
        self.navigationController?.pushViewController(itemVC, animated: true)
        let ip = tableView.indexPathForSelectedRow
        _ = tableView.cellForRow(at: ip!)
        if indexPath.section == 0
        {
            let u1:PFObject = self.lost_reports[indexPath.row]
            self.objid = u1.objectId!
        }
        else
        {
            let u1:PFObject = self.found_reports[indexPath.row]
            self.objid = u1.objectId!
        }
        itemVC.object_id = self.objid
    }
    
    // function to delete an item while swiping the cell
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            if indexPath.section == 0
            {
                let ac = UIAlertController(title: "Are you sure?", message: "Deleting this item will delete its data.", preferredStyle: UIAlertControllerStyle.alert)
                let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: { (action) in
                    let u1:PFObject = self.lost_reports[indexPath.row]
                    let u2 = u1.object(forKey: "pname") as? String
                    let query = PFQuery(className: "reported")
                    query.whereKey("email", equalTo: self.email)
                    query.whereKey("pname", equalTo: u2!)
                    u1.deleteInBackground()
                    u1.saveInBackground()
                    self.lost_reports.remove(at: indexPath.row)
                    self.myTable.reloadData()
                })
                ac.addAction(deleteAction)
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil)
                ac.addAction(cancelAction)
                present(ac,animated:true,completion:nil)
            }
            else
            {
                let ac = UIAlertController(title: "Are you sure?", message: "Deleting this item will delete its data.", preferredStyle: UIAlertControllerStyle.alert)
                let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: { (action) in
                    let u1:PFObject = self.found_reports[indexPath.row]
                    let u2 = u1.object(forKey: "pname") as? String
                    let query = PFQuery(className: "reported")
                    query.whereKey("email", equalTo: self.email)
                    query.whereKey("pname", equalTo: u2!)
                    u1.deleteInBackground()
                    u1.saveInBackground()
                    self.found_reports.remove(at: indexPath.row)
                    self.myTable.reloadData()
                })
                ac.addAction(deleteAction)
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil)
                ac.addAction(cancelAction)
                present(ac,animated:true,completion:nil)
            }
        }
    }
}
