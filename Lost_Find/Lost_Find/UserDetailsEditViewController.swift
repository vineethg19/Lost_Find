//
//  UserDetailsEditViewController.swift
//  Lost_Find
//
//  Created by Gajula,Vineeth on 3/26/17.
//  Copyright © 2017 nwmsu. All rights reserved.
//

import UIKit
import Parse

// To edit the users details like firstName, lastName and phoneNumber
class UserDetailsEditViewController: UIViewController ,UITextFieldDelegate{
    
    var email = ""
    var objectId = ""
    var newF = ""
    var newL = ""
    var newPhone = ""
    var b:Bool = false
    var Sharedemail = ""

    @IBOutlet weak var fnameEdit: UITextField!
    @IBOutlet weak var phnEdit: UITextField!
    @IBOutlet weak var lnameEdit: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fnameEdit.delegate = self
        phnEdit.delegate = self
        lnameEdit.delegate = self
    }

    // exits keyboard when touches outside the keyboard while editing
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Keyboard goes away after clicking return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        fnameEdit.resignFirstResponder()
        lnameEdit.resignFirstResponder()
        phnEdit.resignFirstResponder()
        return true
    }
    
    // getting the currenlty logged user details
    override func viewWillAppear(_ animated: Bool) {
        if  let currentUser = PFUser.current()
        {
            self.fnameEdit.text = currentUser["fname"] as! String?
            self.lnameEdit.text = currentUser["lname"] as! String?
            self.phnEdit.text = currentUser["PhoneNumber"] as! String?
        }
    }
    
    // saves the user's details with some validation to check for empty fields.
    @IBAction func saveDetails(_ sender: Any) {
        if((self.fnameEdit.text?.isEmpty)! || (self.lnameEdit.text?.isEmpty)! || (self.phnEdit.text?.isEmpty)!)
        {
            let alert = UIAlertController(title: "Alert", message: "Please Entere All Fields!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated:true, completion: nil)
        }
        else 
        {
            if  let currentUser = PFUser.current()
            {
                currentUser["fname"] = self.fnameEdit.text
                currentUser["lname"] = self.lnameEdit.text
                currentUser["PhoneNumber"] = self.phnEdit.text
                currentUser.saveInBackground()
            }
            let alert = UIAlertController(title: "Success", message: "Details successfully updated!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
