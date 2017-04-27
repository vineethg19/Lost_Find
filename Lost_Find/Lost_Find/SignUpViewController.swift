//
//  SignUpViewController.swift
//  Lost_Find
//
//  Created by appleGeek on 3/18/17.
//  Copyright © 2017 nwmsu. All rights reserved.
//

import UIKit
import Parse

// Class which controlls the user signup.
class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var fName: UITextField!
    @IBOutlet weak var lName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pwd: UITextField!
    @IBOutlet weak var cpwd: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    // executes only once after the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fName.delegate = self
        self.lName.delegate = self
        self.email.delegate = self
        self.pwd.delegate = self
        self.cpwd.delegate = self
        self.phone.delegate = self
    }
    
    // keyboard goes away after clickling return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        fName.resignFirstResponder()
        lName.resignFirstResponder()
        email.resignFirstResponder()
        pwd.resignFirstResponder()
        cpwd.resignFirstResponder()
        phone.resignFirstResponder()
        return true
    }
    
    // validations for sign up and creating users
    @IBAction func signUp(_ sender: Any) {
        
        let first_name = self.fName.text
        let last_name = self.lName.text
        var email = self.email.text
        var phone = self.phone.text
        var pwd = self.pwd.text
        let cpwd = self.cpwd.text
        // Validating the text fields
        if ((first_name?.isEmpty)! || (last_name?.isEmpty)! || (email?.isEmpty)! || (pwd?.isEmpty)! || (cpwd?.isEmpty)! || (phone?.isEmpty)!)
        {
            let alert = UIAlertController(title: "Invalid", message: "Please Enter all fields", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated:true, completion: nil)
        }
        else if pwd != cpwd {
            let alert = UIAlertController(title: "Invalid", message: "Password doesn't match", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated:true, completion: nil)
            
        } else if (phone?.characters.count)! < 10 {
            let alert = UIAlertController(title: "Invalid", message: "Please enter a valid Phone Number", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated:true, completion: nil)
            
            
        } else if (email?.characters.count)! < 8 {
            let alert = UIAlertController(title: "Invalid", message: "Please enter a valid Email Address", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated:true, completion: nil)
        }
        else if ((pwd?.characters.count)! < 8 ){
            let alert = UIAlertController(title: "Invalid", message: "Please enter a valid Password atleast 8 characters", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated:true, completion: nil)
        }
        else {
            let User = PFUser()
            User.username = email  // email is your username which is required for login i.e onlt with email
            User.password = pwd
            User["fname"] = first_name
            User["lname"] = last_name
            User["PhoneNumber"] = phone
            User.signUpInBackground( block: {
                (success, error) -> Void in
                if let error = error as NSError? {
                    var errorString = error.userInfo["error"] as? NSString
                    errorString = "Users already exists for this email"
                    let alert = UIAlertController(title: "OOPS", message: "\(errorString!)", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated:true, completion: nil)
                }
                else {
                    let alert:UIAlertController = UIAlertController(title: "Success", message: "You have Successfully Registered!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title:"OK", style: .default, handler: { action in self.performSegue(withIdentifier: "login", sender: self)}))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    // handles memory issues
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
