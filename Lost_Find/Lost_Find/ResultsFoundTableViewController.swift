//
//  ResultsFoundTableViewController.swift
//  Lost_Find
//
//  Created by appleGeek on 4/1/17.
//  Copyright © 2017 nwmsu. All rights reserved.
//

import UIKit
import Parse

// displays the detailed information about user,item etc
class ResultsFoundTableViewController: UITableViewController {
    
    var objID = ""
    var email = ""
    var userfound = ""
    var foundID = ""
    var fname = ""
    var lname = ""
    var phone = ""
    var fullname = ""
    var contactDetails = [String]()
    var arr1 = [""]
    var locationDetails = [String]()
    var itemDetails = [String]()
    var state = ""
    var city = ""
    var desc = ""
    var color = ""
    var brand = ""
    var product = ""
    var user = ""
    
    @IBOutlet var mytable: UITableView!
    
    // reloads tableVIew
    override func viewDidLoad() {
        super.viewDidLoad()
        mytable.reloadData()
    }
    
    // fetches the users information and stores in contactDetails array and calls loadUser()
    override func viewWillAppear(_ animated: Bool) {
        let q = PFQuery(className: "_User")
        q.whereKey("username", equalTo: self.email)
        q.findObjectsInBackground { (result:[PFObject]?, err:Error?) in
            for obj in result!
            {
                self.fname = obj["fname"] as! String
                self.lname = obj["lname"] as! String
                self.fullname = "Name: \(self.fname) \(self.lname)"
                self.phone = obj["PhoneNumber"] as! String
                self.phone = "Phone Number: \(self.phone)"
                self.email = "Email: \(self.email)"
                self.contactDetails = [self.fullname,self.phone,self.email]
                self.mytable.reloadData()
            }
            self.loadUser()
        }
    }
    
    //  fetches the location and item information and stores it in arrays
    func loadUser()
    {
        let q = PFQuery(className: "report")
        q.whereKey("objectId", equalTo: self.objID)
        q.findObjectsInBackground { (result:[PFObject]?, err:Error?) in
            for obj in result!
            {
                self.product = obj["pname"] as! String
                self.product = "Product Name: \(self.product)"
                self.brand = obj["bname"] as! String
                self.brand = "Brand Name: \(self.brand)"
                self.color = obj["color"] as! String
                self.color = "Color: \(self.color)"
                self.desc = obj["description"] as! String
                self.desc = "Description: \(self.desc)"
                self.state = obj["state"] as! String
                self.state = "State: \(self.state)"
                self.city = obj["city"] as! String
                self.city = "City: \(self.city)"
                self.itemDetails = [self.product,self.brand,self.color,self.desc]
                self.locationDetails = [self.state,self.city]
                self.mytable.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   // 3 sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    // returns count of the arrays to list the rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0
        {
            return contactDetails.count
        }
        else if section == 1{
            return locationDetails.count
        }
        else
        {
            return itemDetails.count
        }
        
    }
    
    // titles for 3 sections
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0
        {
            return "Found By"
        }
        else if  section == 1
        {
            return "Found At"
        }
        else
        {
            return "Item Details"
        }
        
    }
    
    // setting the font,size and color for the headers in the sections
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.gray
        let headerLabel = UILabel(frame: CGRect(x: 15, y: 0, width:
        tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        headerLabel.textColor = UIColor.white
        headerLabel.text = self.tableView(self.tableView, titleForHeaderInSection: section)
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        return headerView
    }
    
    // setting the header height to: 35
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    // displaying each cell information from the arrays we stored previously
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "user", for: indexPath)
            cell.textLabel!.text = self.contactDetails[indexPath.row]
            return cell
            
        }
        else if indexPath.section == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "location", for: indexPath)
            cell.textLabel!.text = self.locationDetails[indexPath.row]
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath)
            cell.textLabel!.text = self.itemDetails[indexPath.row]
            return cell
        }
    }
}
