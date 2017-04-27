//
//  FirstViewController.swift
//  Lost? Find.
//
//  Created by Gajula,Vineeth on 2/10/17.
//  Copyright © 2017 Gajula,Vineeth. All rights reserved.
//

import UIKit
import Parse

// class to report items.
class ReportViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource , UITextFieldDelegate{
    
    var lostfound=["---","Lost","Found"]
    var states=["---","MO","OH","KS","TX"]
    var state_MO = ["---","Maryville","Kansas City","St. Louis","Springfield","Jefferson City","St. Joseph"]
    var state_OH = ["---","Cleveland","Cincinnati","Columbus","Toledo","Akron","Dayton"]
    var state_TX = ["---","Dallas","Houston","Austin","Plano","Arlington","San Antonio"]
    var state_KS = ["---","Wichita","Kansas City","Topeka","Overland Park","Olathe","Lenexa"]
    var selectedUser:PFUser?
    var userArray = [PFUser]()
    var svalue:String = ""
    var cvalue:String = ""
    var rvalue:String = ""
    var objID = ""
    var user_name = ""
    var dateSelected = ""
    var prod = ""
    
    @IBOutlet weak var dateVariable: UIDatePicker!
    @IBOutlet weak var brand_name: UITextField!
    @IBOutlet weak var color: UITextField!
    @IBOutlet weak var product_name: UITextField!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var picker1: UIPickerView! // lost found
    @IBOutlet weak var picker2: UIPickerView! // states
    @IBOutlet weak var picker3: UIPickerView! // cities
    @IBOutlet weak var desc: UITextField!
    
    // to format the default date
    @IBAction func dateFunction(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        dateSelected = dateFormatter.string(from: dateVariable.date)
        
    }
    
    // keyboard goes away after clickling return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        brand_name.resignFirstResponder()
        product_name.resignFirstResponder()
        desc.resignFirstResponder()
        color.resignFirstResponder()
        return true
    }
    
    // executes every time when the view is loaded
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rvalue = ""
        let username = PFUser.current()
        user_name = (username?.username)!
        
    }
    
    // executes only once after the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        brand_name.delegate = self
        product_name.delegate = self
        desc.delegate = self
        color.delegate = self
        picker1.delegate = self
        picker1.dataSource = self
        picker2.delegate = self
        picker2.dataSource = self
        picker3.delegate = self
        picker3.dataSource = self
        dateVariable.datePickerMode = .date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        dateSelected = dateFormatter.string(from: dateVariable.date)
        dateVariable.addTarget(self, action: #selector(ReportViewController.dateFunction(_:)), for: UIControlEvents.valueChanged)
    }
    
    // clears the fields
    @IBAction func clearAll(_ sender: Any) {
        if((product_name.text?.isEmpty)! && (brand_name.text?.isEmpty)! && (color.text?.isEmpty)! && (desc.text?.isEmpty)!)
        {
            let alert = UIAlertController(title: "Alert", message: "Fields are already empty.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated:true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "Alert", message: "All fields has been reset!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated:true, completion: nil)
            brand_name.text = ""
            product_name.text = ""
            desc.text = ""
            color.text = ""
        }
    }
    
    // reports the item to the list and validates if there are any empty fields.
    @IBAction func report(_ sender: Any) {
        if rvalue == "---"
        {
            rvalue = ""
        }
        if svalue == "---"
        {
            svalue = ""
        }
        if cvalue == "---"
        {
            cvalue = ""
        }
        
        if((product_name.text?.isEmpty)! || (brand_name.text?.isEmpty)! || (color.text?.isEmpty)! || (desc.text?.isEmpty)! ||
            rvalue == "" || svalue == "" || cvalue == "" )
        {
            let alert = UIAlertController(title: "Alert", message: "Please Enter All Fields", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated:true, completion: nil)
        }
        else{
            let reportItems = PFObject(className: "report")
            reportItems["pname"] = self.product_name.text!.lowercased()
            reportItems["bname"] = self.brand_name.text!.lowercased()
            reportItems["color"] = self.color.text!.lowercased()
            reportItems["state"] = svalue
            reportItems["city"] = cvalue
            reportItems["reported"] = String(rvalue)
            reportItems["description"] = String(self.desc.text!)
            reportItems["email"] = self.user_name // shared data from loginVC
            reportItems["date"] = self.dateSelected
            reportItems.saveInBackground(block: { (check:Bool, error:Error?) in
                if check{
                    let obj = reportItems.objectId
                    self.objID = obj!
                    let navC = self.tabBarController?.viewControllers![2] as! UINavigationController // 2 because 0,1,2 is index and 2nd one contains tableviewcontroller
                    let vc = navC.topViewController as! TableViewController
                    vc.objid = self.objID
                }
            })
            let alert = UIAlertController(title: "Sucesss", message: "Item reported", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated:true, completion: nil)
            brand_name.text = ""
            product_name.text = ""
            desc.text = ""
            color.text = ""
        }
    }
    
    // picker view for getting the selected value
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == picker1)
        {
            rvalue = lostfound[row] as String
        }
        else if pickerView == picker2
        {
            svalue = states[row] as String
            picker3.reloadAllComponents()
        }
        else if pickerView == picker3
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
    
    // used for memory warnings
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // displays only one component in picker views
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // displays the # of rows in each picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView==picker1
        {
            return lostfound.count
        }
        else if pickerView==picker2
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
    
    // title for the pickers which has to be selected
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView==picker1
        {
            
            return lostfound[row]
        }
        else if pickerView==picker2
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

