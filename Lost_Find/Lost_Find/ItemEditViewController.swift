//
//  ItemEditViewController.swift
//  Lost_Find
//
//  Created by appleGeek on 3/20/17.
//  Copyright © 2017 nwmsu. All rights reserved.
//

import UIKit
import Parse

// To edit the Reported Item's details
class ItemEditViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate {
    
    var tempDate = ""
    var rvalue = ""
    var svalue = ""
    var cvalue = ""
    var dateSelected = ""
    var unwind_data1 = ""
    var object_id = ""
    var lostfound=["---","Lost","Found"]
    var states=["---","MO","OH","KS","TX"]
    var MO = ["---","Maryville","Kansas City","St. Louis","Springfield","Jefferson City","St. Joseph"]
    var OH = ["---","Cleveland","Cincinnati","Columbus","Toledo","Akron","Dayton"]
    var TX = ["---","Dallas","Houston","Austin","Plano","Arlington","San Antonio"]
    var KS = ["---","Wichita","Kansas City","Topeka","Overland Park","Olathe","Lenexa"]
    
    @IBOutlet weak var pnameTF: UITextField!
    @IBOutlet weak var statePicker: UIPickerView!
    @IBOutlet weak var picker1: UIPickerView!
    @IBOutlet weak var cityPicker: UIPickerView!
    @IBOutlet weak var dateVariable: UIDatePicker!
    @IBOutlet weak var descTF: UITextField!
    @IBOutlet weak var colorTF: UITextField!
    @IBOutlet weak var bnameTF: UITextField!

    // to format the default datePicker
    @IBAction func dateFunction(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        dateSelected = dateFormatter.string(from: dateVariable.date)   
    }
    
    // exits keyboard when touches outside the keyboard while editing
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pnameTF.resignFirstResponder()
        descTF.resignFirstResponder()
        bnameTF.resignFirstResponder()
        colorTF.resignFirstResponder()
        return true
    }
    
    // loads the picker view delegates and calls the dateFunction() to set the new date format
    override func viewDidLoad() {
        super.viewDidLoad()
        picker1.delegate=self
        picker1.dataSource=self
        statePicker.delegate=self
        statePicker.dataSource=self
        cityPicker.delegate=self
        cityPicker.dataSource=self
        descTF.delegate = self
        colorTF.delegate = self
        pnameTF.delegate = self
        bnameTF.delegate = self
        dateVariable.datePickerMode = .date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        dateSelected = dateFormatter.string(from: dateVariable.date)
        dateVariable.addTarget(self, action: #selector(ItemEditViewController.dateFunction(_:)), for: UIControlEvents.valueChanged)
    }
    
    // calls loadItems() whenever view appears
    override func viewWillAppear(_ animated: Bool) {
        loadItems()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // saves the item
    @IBAction func saveItem(_ sender: Any) {
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
        if((pnameTF.text?.isEmpty)! || (bnameTF.text?.isEmpty)! || (colorTF.text?.isEmpty)! || (descTF.text?.isEmpty)! || rvalue == "" || svalue == "" || cvalue == "")
        {
            let alert = UIAlertController(title: "Alert", message: "Please Enter All Fields", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated:true, completion: nil)
        }
        else{
            
            let query = PFQuery(className: "report")
            query.whereKey("objectId",equalTo: self.object_id)
            query.findObjectsInBackground(block: { (result:[PFObject]?, error:Error?) in
                for objects in result!{
                    objects["pname"] = self.pnameTF.text!
                    objects["bname"] = self.bnameTF.text!
                    objects["color"] = self.colorTF.text!
                    objects["state"] = self.svalue
                    objects["city"] = self.cvalue
                    objects["reported"] = String(self.rvalue)
                    objects["description"] = String(self.descTF.text!)
                    objects["date"] = self.dateSelected
                    objects.saveInBackground()
                    self.unwind_data1 = self.pnameTF.text!
                }
            })
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object:nil)
            let alert = UIAlertController(title: "Sucesss", message: "Item Saved Successfully!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title:"OK", style: .default, handler:nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    // displays all the picker values and lists cities according to the state selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == picker1)
        {
            rvalue = lostfound[row] as String
        }
        else if pickerView == statePicker
        {
            svalue = states[row] as String
            cityPicker.reloadAllComponents()
        }
        else if pickerView == cityPicker
        {
            if svalue == "MO"
            {
                cvalue = MO[row]
            }
            else if svalue == "KS"
            {
                cvalue = KS[row]
            }
            else if svalue == "OH"
            {
                cvalue = OH[row]
            }
            else if svalue == "TX"
            {
                cvalue = TX[row]
            }
            else
            {
                cvalue = "---"
            }
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the number of components for the pickers. Since we have 6 cities for every state, so returning 6.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView==picker1
        {
            return lostfound.count
        }
        else if pickerView==statePicker
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

    // titles for each picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView==picker1
        {
            
            return lostfound[row]
        }
        else if pickerView==statePicker
        {
            return states[row]
        }
        else
        {
            if svalue == "MO"
            {
                return MO[row]
                
            }
            else if svalue == "OH"
            {
                return OH[row]
            }
                
            else if svalue == "TX"
            {
                return TX[row]
            }
            else if svalue == "KS"
            {
                return KS[row]
            }
            return "---"
        }
    }
    
    // loads the Item Description
    func loadItems()
    {
        let userQuery = PFQuery(className: "report")
        userQuery.whereKey("objectId",equalTo: self.object_id)
        userQuery.findObjectsInBackground { (result:[PFObject]?, error:Error?) in
            if error == nil
            {
                for object in result!
                {
                    self.pnameTF.text = object.value(forKey: "pname") as! String?
                    self.bnameTF.text = object.value(forKey: "bname") as! String?
                    self.colorTF.text = object.value(forKey: "color") as! String?
                    self.tempDate = (object.value(forKey: "date") as! String?)!
                    self.descTF.text = object["description"] as? String // accessing in different way as desc is of type dictionary
                }
            }
            else
            {
                print(error!)
            }
        } // query ends
    } // func ends
} // class ends
