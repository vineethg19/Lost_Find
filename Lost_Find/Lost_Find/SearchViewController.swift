//
//  SearchViewController.swift
//  Lost? Find.
//
//  Created by appleGeek on 3/5/17.
//  Copyright © 2017 Gajula,Vineeth. All rights reserved.
//

import UIKit
import Parse

// Class used for implementing search for the items.
class SearchViewController: UIViewController ,UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {
    var emails = [String]()
    var objectIDs = [String]()
    var pname = ""
    var states=["---","MO","OH","TX","KS"]
    var state_MO = ["---","Maryville","Kansas City","St. Louis","Springfield","Jefferson City","St. Joseph"]
    var state_OH = ["---","Cleveland","Cincinnati","Columbus","Toledo","Akron","Dayton"]
    var state_TX = ["---","Dallas","Houston","Austin","Plano","Arlington","San Antonio"]
    var state_KS = ["---","Wichita","Kansas City","Topeka","Overland Park","Olathe","Lenexa"]
    var userID = ""
    var email = ""
    var p_count = 0
    var c_count = 0
    var b_count = 0
    var temp_p = ""
    var temp_b = ""
    var temp_c = ""
    var temp_date = ""
    var temp_state = ""
    var temp_city = ""
    var svalue = ""
    var cvalue = ""
    var user_found = ""
    var found_ID = ""
    var send_pname = ""
    var send_fname = ""
    var send_lname = ""
    var send_phone = ""
    var send_date = ""
    var send_state = ""
    var send_city = ""
    var send_desc = ""
    var send_bname = ""
    var send_color = ""
    var id = ""
    var dateSelected = ""
    
    @IBOutlet weak var dateVariable: UIDatePicker!
    @IBOutlet weak var color_search: UITextField!
    @IBOutlet weak var brand_search: UITextField!
    @IBOutlet weak var product_search: UITextField!
    @IBOutlet weak var cityPick: UIPickerView!
    @IBOutlet weak var statePick: UIPickerView!

    // executes only once after the viewcontroller loads
    override func viewDidLoad() {
        super.viewDidLoad()
        statePick.delegate=self
        statePick.dataSource=self
        cityPick.delegate=self
        cityPick.dataSource=self
        self.temp_state = ""
        self.temp_city = ""
        dateVariable.datePickerMode = .date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        dateSelected = dateFormatter.string(from: dateVariable.date)
        dateVariable.addTarget(self, action: #selector(SearchViewController.dateFunction(_:)), for: UIControlEvents.valueChanged)
    }
    
    // formatting the uiDatePicker
    @IBAction func dateFunction(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        dateSelected = dateFormatter.string(from: dateVariable.date)
    }
    
    // exits keyboard when touches view while editing
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
 
    // Keyboard goes away after clicking return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        product_search.delegate = self
        color_search.delegate = self
        brand_search.delegate = self
        product_search.resignFirstResponder()
        color_search.resignFirstResponder()
        brand_search.resignFirstResponder()
        return true
    }
    
    // executes each time when the view appears
    override func viewWillAppear(_ animated: Bool) {
        let username = PFUser.current()
        userID = (username?.objectId!)!
        email = (username?.username)!
        self.emails.removeAll()  //clearing emails and obj id's
        self.objectIDs.removeAll()
        
    }
    
    // search criteria 1 - querying the data if all the fields are given by the user.
    func search1()
    {
        let query = PFQuery(className: "report")
        query.whereKey("email", notEqualTo: self.email)
        query.whereKey("reported", equalTo: "Found")
        query.findObjectsInBackground(block: { (objects:[PFObject]?, err:Error?) in
            for obj in objects!
            {
                if self.temp_p == obj["pname"] as! String
                {
                    if self.temp_b == obj["bname"] as! String
                    {
                        if self.temp_c == obj["color"] as! String
                        {
                            if self.temp_date == obj["date"] as! String
                            {
                                if self.temp_state == obj["state"] as! String
                                {
                                    if self.temp_city == obj["city"] as! String
                                    {
                                        let email = (obj["email"] as! String)
                                        let objID = obj.objectId!
                                        self.emails.append(email)
                                        self.objectIDs.append(objID)
                                    }
                                }
                            }
                        }
                    }
                    
                }
            }
            self.pname = self.product_search.text!
            if(self.emails.count > 0)
            {
                let alert = UIAlertController(title: "Greetings!", message: "Total \(self.emails.count) results found!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title:"OK", style: .default, handler: { action in self.performSegue(withIdentifier: "fetchreports", sender: self)}))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "OOPS", message: "No items Found!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated:true, completion: nil)
            }
        })
    }
    
    // search criteria 2 - querying the data if Product Name, State and Date fields are given by the user.
    func search2()
    {
        let query = PFQuery(className: "report")
        query.whereKey("email", notEqualTo: self.email)
        query.whereKey("reported", equalTo: "Found")
        query.findObjectsInBackground(block: { (objects:[PFObject]?, err:Error?) in
            for obj in objects!
            {
                if self.temp_p == obj["pname"] as! String
                {
                    if self.temp_state == obj["state"] as! String
                    {
                        if self.temp_date == obj["date"] as! String
                        {
                            let email = (obj["email"] as! String)
                            let objID = obj.objectId!
                            self.emails.append(email)
                            self.objectIDs.append(objID)
                        }
                    }
                    
                }
            }
            self.pname = self.product_search.text!
            if(self.emails.count > 0)
            {
                let alert = UIAlertController(title: "Greetings!", message: "Total \(self.emails.count) results found!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title:"OK", style: .default, handler: { action in self.performSegue(withIdentifier: "fetchreports", sender: self)}))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "OOPS", message: "No items Found!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated:true, completion: nil)
            }
        })
    }
    
    // search criteria 3 - querying the data if Product Name, City and Date fields are given by the user.
    func search3()
    {
        let query = PFQuery(className: "report")
        query.whereKey("email", notEqualTo: self.email)
        query.whereKey("reported", equalTo: "Found")
        query.findObjectsInBackground(block: { (objects:[PFObject]?, err:Error?) in
            for obj in objects!
            {
                if self.temp_p == obj["pname"] as! String
                {
                    if self.temp_city == obj["city"] as! String
                    {
                        if self.temp_date == obj["date"] as! String
                        {
                            let email = (obj["email"] as! String)
                            let objID = obj.objectId!
                            self.emails.append(email)
                            self.objectIDs.append(objID)
                        }
                    }
                }
            }
            self.pname = self.product_search.text!
            if(self.emails.count > 0)
            {
                let alert = UIAlertController(title: "Greetings!", message: "Total \(self.emails.count) results found!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title:"OK", style: .default, handler: { action in self.performSegue(withIdentifier: "fetchreports", sender: self)}))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "OOPS", message: "No items Found!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated:true, completion: nil)
            }
        })
    }
    
    //search criteria 4 - querying the data if Product Name, State, Date and City fields are given by the user.
    func search4()
    {
        let query = PFQuery(className: "report")
        query.whereKey("email", notEqualTo: self.email)
        query.whereKey("reported", equalTo: "Found")
        query.findObjectsInBackground(block: { (objects:[PFObject]?, err:Error?) in
            for obj in objects!
            {
                if self.temp_p == obj["pname"] as! String
                {
                    if self.temp_state == obj["state"] as! String
                    {
                        if self.temp_date == obj["date"] as! String
                        {
                            if self.temp_city == obj["city"] as! String{
                                
                                let email = (obj["email"] as! String)
                                let objID = obj.objectId!
                                self.emails.append(email)
                                self.objectIDs.append(objID)
                            }
                        }
                    }
                }
            }
            self.pname = self.product_search.text!
            if(self.emails.count > 0)
            {
                let alert = UIAlertController(title: "Greetings!", message: "Total \(self.emails.count) results found!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title:"OK", style: .default, handler: { action in self.performSegue(withIdentifier: "fetchreports", sender: self)}))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "OOPS", message: "No items Found!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated:true, completion: nil)
            }
        })
    }
    
    // search criteria 5 - querying the data if Product Name, Brand Name and Date fields are given by the user.
    func search5()
    {
        let query = PFQuery(className: "report")
        query.whereKey("email", notEqualTo: self.email)
        query.whereKey("reported", equalTo: "Found")
        query.findObjectsInBackground(block: { (objects:[PFObject]?, err:Error?) in
            for obj in objects!
            {
                if self.temp_p == obj["pname"] as! String
                {
                    
                    if self.temp_date == obj["date"] as! String
                    {
                        if self.temp_b == obj["bname"] as! String{
                            
                            let email = (obj["email"] as! String)
                            let objID = obj.objectId!
                            self.emails.append(email)
                            self.objectIDs.append(objID)
                        }
                    }
                }
            }
            self.pname = self.product_search.text!
            if(self.emails.count > 0)
            {
                let alert = UIAlertController(title: "Greetings!", message: "Total \(self.emails.count) results found!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title:"OK", style: .default, handler: { action in self.performSegue(withIdentifier: "fetchreports", sender: self)}))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "OOPS", message: "No items Found!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated:true, completion: nil)
            }
        })
    }
    
    // search criteria 6 - querying the data if Product Name, Brand Name, State and Date fields are given by the user.
    func search6()
    {
        let query = PFQuery(className: "report")
        query.whereKey("email", notEqualTo: self.email)
        query.whereKey("reported", equalTo: "Found")
        query.findObjectsInBackground(block: { (objects:[PFObject]?, err:Error?) in
            for obj in objects!
            {
                if self.temp_p == obj["pname"] as! String
                {
                    if self.temp_state == obj["state"] as! String
                    {
                        if self.temp_date == obj["date"] as! String
                        {
                            if self.temp_b == obj["bname"] as! String{
                                
                                let email = (obj["email"] as! String)
                                let objID = obj.objectId!
                                self.emails.append(email)
                                self.objectIDs.append(objID)
                            }
                        }
                    }
                }
            }
            self.pname = self.product_search.text!
            if(self.emails.count > 0)
            {
                let alert = UIAlertController(title: "Greetings!", message: "Total \(self.emails.count) results found!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title:"OK", style: .default, handler: { action in self.performSegue(withIdentifier: "fetchreports", sender: self)}))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "OOPS", message: "No items Found!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated:true, completion: nil)
            }
        })
    }
    
    // search criteria 7 - querying the data if Product Name, Brand Name,City and Date fields are given by the user.
    func search7()
    {
        let query = PFQuery(className: "report")
        query.whereKey("email", notEqualTo: self.email)
        query.whereKey("reported", equalTo: "Found")
        query.findObjectsInBackground(block: { (objects:[PFObject]?, err:Error?) in
            for obj in objects!
            {
                if self.temp_p == obj["pname"] as! String
                {
                    if self.temp_city == obj["city"] as! String
                    {
                        if self.temp_date == obj["date"] as! String
                        {
                            if self.temp_b == obj["bname"] as! String{
                                
                                let email = (obj["email"] as! String)
                                let objID = obj.objectId!
                                self.emails.append(email)
                                self.objectIDs.append(objID)
                            }
                        }
                    }
                }
            }
            self.pname = self.product_search.text!
            if(self.emails.count > 0)
            {
                let alert = UIAlertController(title: "Greetings!", message: "Total \(self.emails.count) results found!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title:"OK", style: .default, handler: { action in self.performSegue(withIdentifier: "fetchreports", sender: self)}))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "OOPS", message: "No items Found!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated:true, completion: nil)
            }
        })
    }
    
    // search criteria 8 - querying the data if Product Name, Brand Name,City, State and Date fields are given by the user.
    func search8()
    {
        let query = PFQuery(className: "report")
        query.whereKey("email", notEqualTo: self.email)
        query.whereKey("reported", equalTo: "Found")
        query.findObjectsInBackground(block: { (objects:[PFObject]?, err:Error?) in
            for obj in objects!
            {
                if self.temp_p == obj["pname"] as! String
                {
                    if self.temp_city == obj["city"] as! String
                    {
                        if self.temp_date == obj["date"] as! String
                        {
                            if self.temp_b == obj["bname"] as! String{
                                if self.temp_state == obj["state"] as! String{
                                    
                                    let email = (obj["email"] as! String)
                                    let objID = obj.objectId!
                                    self.emails.append(email)
                                    self.objectIDs.append(objID)
                                }
                            }
                        }
                    }
                }
            }
            self.pname = self.product_search.text!
            if(self.emails.count > 0)
            {
                let alert = UIAlertController(title: "Greetings!", message: "Total \(self.emails.count) results found!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title:"OK", style: .default, handler: { action in self.performSegue(withIdentifier: "fetchreports", sender: self)}))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "OOPS", message: "No items Found!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated:true, completion: nil)
            }
        })
    }
    
    // search criteria 9 - querying the data if Product Name, Color and Date fields are given by the user.
    func search9()
    {
        let query = PFQuery(className: "report")
        query.whereKey("email", notEqualTo: self.email)
        query.whereKey("reported", equalTo: "Found")
        query.findObjectsInBackground(block: { (objects:[PFObject]?, err:Error?) in
            for obj in objects!
            {
                if self.temp_p == obj["pname"] as! String
                {
                    if self.temp_c == obj["color"] as! String
                    {
                        if self.temp_date == obj["date"] as! String
                        {
                            
                            let email = (obj["email"] as! String)
                            let objID = obj.objectId!
                            self.emails.append(email)
                            self.objectIDs.append(objID)
                        }
                    }
                }
            }
            self.pname = self.product_search.text!
            if(self.emails.count > 0)
            {
                let alert = UIAlertController(title: "Greetings!", message: "Total \(self.emails.count) results found!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title:"OK", style: .default, handler: { action in self.performSegue(withIdentifier: "fetchreports", sender: self)}))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "OOPS", message: "No items Found!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated:true, completion: nil)
            }
        })
    }
    
    // search criteria 10 - querying the data if Product Name, Color, State and Date fields are given by the user.
    func search10()
    {
        let query = PFQuery(className: "report")
        query.whereKey("email", notEqualTo: self.email)
        query.whereKey("reported", equalTo: "Found")
        query.findObjectsInBackground(block: { (objects:[PFObject]?, err:Error?) in
            for obj in objects!
            {
                if self.temp_p == obj["pname"] as! String
                {
                    if self.temp_c == obj["color"] as! String
                    {
                        if self.temp_date == obj["date"] as! String
                        {
                            if self.temp_state == obj["state"] as! String{
                                
                                let email = (obj["email"] as! String)
                                let objID = obj.objectId!
                                self.emails.append(email)
                                self.objectIDs.append(objID)
                            }
                        }
                    }
                }
            }
            self.pname = self.product_search.text!
            if(self.emails.count > 0)
            {
                let alert = UIAlertController(title: "Greetings!", message: "Total \(self.emails.count) results found!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title:"OK", style: .default, handler: { action in self.performSegue(withIdentifier: "fetchreports", sender: self)}))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "OOPS", message: "No items Found!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated:true, completion: nil)
            }
            
        })
    }
    
    // search criteria 11 - querying the data if Product Name, Color, City, Date fields are given by the user.
    func search11()
    {
        let query = PFQuery(className: "report")
        query.whereKey("email", notEqualTo: self.email)
        query.whereKey("reported", equalTo: "Found")
        query.findObjectsInBackground(block: { (objects:[PFObject]?, err:Error?) in
            for obj in objects!
            {
                if self.temp_p == obj["pname"] as! String
                {
                    if self.temp_c == obj["color"] as! String
                    {
                        if self.temp_date == obj["date"] as! String
                        {
                            if self.temp_city == obj["city"] as! String{
                                
                                let email = (obj["email"] as! String)
                                let objID = obj.objectId!
                                self.emails.append(email)
                                self.objectIDs.append(objID)
                            }
                        }
                    }
                }
            }
            self.pname = self.product_search.text!
            if(self.emails.count > 0)
            {
                let alert = UIAlertController(title: "Greetings!", message: "Total \(self.emails.count) results found!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title:"OK", style: .default, handler: { action in self.performSegue(withIdentifier: "fetchreports", sender: self)}))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "OOPS", message: "No items Found!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated:true, completion: nil)
            }
        })
    }
    
    // search criteria 12 - querying the data if Product Name, Color, City, State and Date fields are given by the user.
    func search12()
    {
        let query = PFQuery(className: "report")
        query.whereKey("email", notEqualTo: self.email)
        query.whereKey("reported", equalTo: "Found")
        query.findObjectsInBackground(block: { (objects:[PFObject]?, err:Error?) in
            for obj in objects!
            {
                if self.temp_p == obj["pname"] as! String
                {
                    if self.temp_c == obj["color"] as! String
                    {
                        if self.temp_date == obj["date"] as! String
                        {
                            if self.temp_state == obj["state"] as! String{
                                
                                if self.temp_city == obj["city"] as! String{
                                    
                                    let email = (obj["email"] as! String)
                                    let objID = obj.objectId!
                                    self.emails.append(email)
                                    self.objectIDs.append(objID)
                                }
                            }
                        }
                    }
                }
            }
            self.pname = self.product_search.text!
            if(self.emails.count > 0)
            {
                let alert = UIAlertController(title: "Greetings!", message: "Total \(self.emails.count) results found!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title:"OK", style: .default, handler: { action in self.performSegue(withIdentifier: "fetchreports", sender: self)}))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "OOPS", message: "No items Found!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated:true, completion: nil)
            }
        })
    }
    
    // search criteria 13 - querying the data if only Product Name and Date fields are given by the user.
    func search13()
    {
        let query = PFQuery(className: "report")
        query.whereKey("email", notEqualTo: self.email)
        query.whereKey("reported", equalTo: "Found")
        query.findObjectsInBackground(block: { (objects:[PFObject]?, err:Error?) in
            for obj in objects!
            {
                if self.temp_p == obj["pname"] as! String
                {
                    if self.temp_date == obj["date"] as! String
                    {
                        
                        let email = (obj["email"] as! String)
                        let objID = obj.objectId!
                        self.emails.append(email)
                        self.objectIDs.append(objID)
                    }
                }
            }
            self.pname = self.product_search.text!
            if(self.emails.count > 0)
            {
                let alert = UIAlertController(title: "Greetings!", message: "Total \(self.emails.count) results found!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title:"OK", style: .default, handler: { action in self.performSegue(withIdentifier: "fetchreports", sender: self)}))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "OOPS", message: "No items Found!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated:true, completion: nil)
            }
        })
    }
    
    // search criteria 14 - querying the data if Product Name, Brand Name, Color and Date fields are given by the user.
    func search14()
    {
        let query = PFQuery(className: "report")
        query.whereKey("email", notEqualTo: self.email)
        query.whereKey("reported", equalTo: "Found")
        query.findObjectsInBackground(block: { (objects:[PFObject]?, err:Error?) in
            for obj in objects!
            {
                if self.temp_p == obj["pname"] as! String
                {
                    if self.temp_date == obj["date"] as! String
                    {
                        if self.temp_c == obj["color"] as! String
                        {
                            if self.temp_b == obj["bname"] as! String
                            {
                                let email = (obj["email"] as! String)
                                let objID = obj.objectId!
                                self.emails.append(email)
                                self.objectIDs.append(objID)
                            }
                        }
                    }
                }
            }
            self.pname = self.product_search.text!
            if(self.emails.count > 0)
            {
                let alert = UIAlertController(title: "Greetings!", message: "Total \(self.emails.count) results found!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title:"OK", style: .default, handler: { action in self.performSegue(withIdentifier: "fetchreports", sender: self)}))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "OOPS", message: "No items Found!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated:true, completion: nil)
            }
        })
    }
    
    // search criteria 15 - querying the data if Product Name, Brand Name,Color, State, Date fields are given by the user.
    func search15()
    {
        let query = PFQuery(className: "report")
        query.whereKey("email", notEqualTo: self.email)
        query.whereKey("reported", equalTo: "Found")
        query.findObjectsInBackground(block: { (objects:[PFObject]?, err:Error?) in
            for obj in objects!
            {
                if self.temp_p == obj["pname"] as! String
                {
                    if self.temp_date == obj["date"] as! String
                    {
                        if self.temp_c == obj["color"] as! String
                        {
                            if self.temp_b == obj["bname"] as! String
                            {
                                if self.temp_state == obj["state"] as! String
                                {
                                    let email = (obj["email"] as! String)
                                    let objID = obj.objectId!
                                    self.emails.append(email)
                                    self.objectIDs.append(objID)
                                }
                            }
                        }
                    }
                }
            }
            self.pname = self.product_search.text!
            if(self.emails.count > 0)
            {
                let alert = UIAlertController(title: "Greetings!", message: "Total \(self.emails.count) results found!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title:"OK", style: .default, handler: { action in self.performSegue(withIdentifier: "fetchreports", sender: self)}))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "OOPS", message: "No items Found!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated:true, completion: nil)
            }
        })
    }
    
    // search criteria 16 - querying the data if Product Name, Brand Name,Color,City and Date fields are given by the user.
    func search16()
    {
        let query = PFQuery(className: "report")
        query.whereKey("email", notEqualTo: self.email)
        query.whereKey("reported", equalTo: "Found")
        query.findObjectsInBackground(block: { (objects:[PFObject]?, err:Error?) in
            for obj in objects!
            {
                if self.temp_p == obj["pname"] as! String
                {
                    if self.temp_date == obj["date"] as! String
                    {
                        if self.temp_c == obj["color"] as! String
                        {
                            if self.temp_b == obj["bname"] as! String
                            {
                                if self.temp_city == obj["city"] as! String
                                {
                                    let email = (obj["email"] as! String)
                                    let objID = obj.objectId!
                                    self.emails.append(email)
                                    self.objectIDs.append(objID)
                                }
                            }
                        }
                    }
                }
            }
            self.pname = self.product_search.text!
            if(self.emails.count > 0)
            {
                let alert = UIAlertController(title: "Greetings!", message: "Total \(self.emails.count) results found!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title:"OK", style: .default, handler: { action in self.performSegue(withIdentifier: "fetchreports", sender: self)}))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "OOPS", message: "No items Found!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated:true, completion: nil)
            }
        })
    }
    
    // search criteria 17 - querying the data if Product Name,City and Date fields are given by the user.
    func search17()
    {
        let query = PFQuery(className: "report")
        query.whereKey("email", notEqualTo: self.email)
        query.whereKey("reported", equalTo: "Found")
        query.findObjectsInBackground(block: { (objects:[PFObject]?, err:Error?) in
            for obj in objects!
            {
                if self.temp_p == obj["pname"] as! String
                {
                    if self.temp_date == obj["date"] as! String
                    {
                        if self.temp_city == obj["city"] as! String
                        {
                            let email = (obj["email"] as! String)
                            let objID = obj.objectId!
                            self.emails.append(email)
                            self.objectIDs.append(objID)
                        }
                    }
                }
            }
            self.pname = self.product_search.text!
            if(self.emails.count > 0)
            {
                let alert = UIAlertController(title: "Greetings!", message: "Total \(self.emails.count) results found!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title:"OK", style: .default, handler: { action in self.performSegue(withIdentifier: "fetchreports", sender: self)}))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "OOPS", message: "No items Found!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated:true, completion: nil)
            }
            
        })
    }
    
    // search criteria 18 - querying the data if Product Name,State and Date fields are given by the user.
    func search18()
    {
        let query = PFQuery(className: "report")
        query.whereKey("email", notEqualTo: self.email)
        query.whereKey("reported", equalTo: "Found")
        query.findObjectsInBackground(block: { (objects:[PFObject]?, err:Error?) in
            for obj in objects!
            {
                if self.temp_p == obj["pname"] as! String
                {
                    if self.temp_date == obj["date"] as! String
                    {
                        if self.temp_state == obj["state"] as! String
                        {
                            let email = (obj["email"] as! String)
                            let objID = obj.objectId!
                            self.emails.append(email)
                            self.objectIDs.append(objID)
                        }
                    }
                }
            }
            self.pname = self.product_search.text!
            if(self.emails.count > 0)
            {
                let alert = UIAlertController(title: "Greetings!", message: "Total \(self.emails.count) results found!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title:"OK", style: .default, handler: { action in self.performSegue(withIdentifier: "fetchreports", sender: self)}))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "OOPS", message: "No items Found!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated:true, completion: nil)
            }
        })
    }
    
    // method which executes while user gives fields and click search. Based on the given search criteria, the appropriate search function gets executed.
    @IBAction func search_lost_items(_ sender: Any) {
        temp_p = product_search.text!.lowercased()
        temp_b = brand_search.text!.lowercased()
        temp_c = color_search.text!.lowercased()
        temp_date = self.dateSelected as String
        temp_state = svalue
        temp_city = cvalue

        // making them empty because default value will be "---", if user does'nt choose any value from the picker.
        if temp_state == "---"
        {
            temp_state = ""
        }
        // same as above.
        if temp_city == "---"
        {
            temp_city = ""
        }
        if(temp_p != "" && temp_b != "" && temp_c != "" && temp_date != "" && temp_state != "" && temp_city != "")
        {
            search1()
        }
        else if(temp_p != "" && temp_b == "" && temp_c == "" && temp_date != "" && temp_state != "" && temp_city == "")
        {
            search2()
        }
        else if(temp_p != "" && temp_b == "" && temp_c == "" && temp_date != "" && temp_state != "" && temp_city == "")
        {
            search3()
        }
        else if(temp_p != "" && temp_b == "" && temp_c == "" && temp_date != "" && temp_state != "" && temp_city != "")
        {
            search4()
        }
        else if(temp_p != "" && temp_b != "" && temp_c == "" && temp_date != "" && temp_state == "" && temp_city == "")
        {
            search5()
        }
        else if(temp_p != "" && temp_b != "" && temp_c == "" && temp_date != "" && temp_state != "" && temp_city == "")
        {
            search6()
        }
        else if(temp_p != "" && temp_b != "" && temp_c == "" && temp_date != "" && temp_state == "" && temp_city != "")
        {
            search7()
        }
            
        else if(temp_p != "" && temp_b != "" && temp_c == "" && temp_date != "" && temp_state != "" && temp_city != "")
        {
            search8()
            
        }
            
        else if(temp_p != "" && temp_b == "" && temp_c != "" && temp_date != "" && temp_state == "" && temp_city == "")
        {
            search9()
            
        }
            
        else if(temp_p != "" && temp_b == "" && temp_c != "" && temp_date != "" && temp_state != "" && temp_city == "")
        {
            search10()
            
        }
        else if(temp_p != "" && temp_b == "" && temp_c != "" && temp_date != "" && temp_state == "" && temp_city != "")
        {
            search11()
            
        }
        else if(temp_p != "" && temp_b == "" && temp_c != "" && temp_date != "" && temp_state != "" && temp_city != "")
        {
            search12()
            
        }
        else if(temp_p != "" && temp_b == "" && temp_c == "" && temp_date != "" && temp_state == "" && temp_city == "")
        {
            search13()
            
        }
        else if(temp_p != "" && temp_b != "" && temp_c != "" && temp_date != "" && temp_state == "" && temp_city == "")
        {
            search14()
            
        }
        else if(temp_p != "" && temp_b != "" && temp_c != "" && temp_date != "" && temp_state != "" && temp_city == "")
        {
            search15()
            
        }
        else if(temp_p != "" && temp_b != "" && temp_c != "" && temp_date != "" && temp_state == "" && temp_city != "")
        {
            search16()
            
        }
        else if(temp_p != "" && temp_b == "" && temp_c == "" && temp_date != "" && temp_state == "" && temp_city != "")
        {
            search17()
            
        }
        else if(temp_p != "" && temp_b == "" && temp_c == "" && temp_date != "" && temp_state != "" && temp_city == "")
        {
            search18()
            
        }
        else
        {
            let alert = UIAlertController(title: "Alert", message: "Please Enter Product name.Thank you!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated:true, completion: nil)
        }
   }
    
    // sends details about the item to the results view controller to display them.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fetchitems"
        {
            if let vc = segue.destination as? ResultsFoundTableViewController
            {
                vc.userfound = self.user_found
                vc.foundID = self.found_ID
                vc.fname = self.send_fname
                vc.lname = self.send_lname
                vc.phone = self.send_phone
                vc.product = self.send_pname
                vc.brand = self.send_bname
                vc.color = self.send_color
                vc.state = self.send_state
                vc.city = self.send_city
                vc.desc = self.send_desc
            }
        }
        else if segue.identifier == "fetchreports"
        {
            if let vc = segue.destination as? UsersTableViewController
            {
                vc.emails = self.emails
                vc.product_name = self.pname
                vc.objectIDs = self.objectIDs
            }
        }
        
    }

    // picker contains 1 component
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // displaying appropriate picker values from previous picker.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == statePick
        {
            svalue = states[row] as String
            cityPick.reloadAllComponents()
        }
        else if pickerView == cityPick
        {
            if svalue == "MO"
            {
                cvalue = state_MO[row]
            }
            else if svalue == "KS"
            {
                cvalue = state_KS[row]
            }
            else if svalue == "OH"
            {
                cvalue = state_OH[row]
            }
            else if svalue == "TX"
            {
                cvalue = state_TX[row]
            }
            else
            {
                cvalue = "---"
            }
        }
    }

    // used for handling memory
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // displaying number of rows in pickerviews. giving city picker '6' because we only have 6 cities for each of the states.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView==statePick
        {
            return states.count
        }
        else
        {
            if svalue == "---"
            {
                return 1
            }
            else
            {
                return 6
            }
        }
    }
    
    // listing appropriate cities after selecting a state.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView==statePick
        {
            return states[row]
        }
        else
        {
            if svalue == "MO"
            {
                return state_MO[row]
                
            }
            else if svalue == "OH"
            {
                return state_OH[row]
            }
                
            else if svalue == "TX"
            {
                return state_TX[row]
            }
            else if svalue == "KS"
            {
                return state_KS[row]
            }
            return "---"
        }
    }

}
