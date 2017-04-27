//
//  LoginViewController.swift
//  Lost_Find
//
//  Created by appleGeek on 3/19/17.
//  Copyright © 2017 nwmsu. All rights reserved.
//

import UIKit
import Parse

// class to user login
class LoginViewController: UIViewController, UITextFieldDelegate{
    
    var  objectID:String = ""
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    // executes only once after the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        self.email.delegate = self
        self.password.delegate = self
        let userQuery = PFQuery(className: "_User")
        userQuery.findObjectsInBackground { (result:[PFObject]?, error:Error?) in
            if error == nil
            {
                for object in result!
                {
                    self.objectID = object.objectId!
                }
            }
            else{
                print(error!)
            }
        }
    }
    
    // keyboard goes away after clickling return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        email.resignFirstResponder()
        password.resignFirstResponder()
        return true
    }

    // used for memory warnings
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // sends data while performing segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginsuccess"
        {
            let destVC = segue.destination as! UITabBarController
            let tab = destVC.viewControllers?[0] as! ReportViewController
            tab.objID = objectID
            tab.user_name = email.text!
        }
        else if segue.identifier == "signupview"
        {
            _ = segue.destination as! SignUpViewController
        }
    }
    
    // user login to validate user and show alerts after validation
    @IBAction func login(_ sender: Any) {
        let email = self.email.text!
        let password = self.password.text!
        if ((email.isEmpty) || (password.isEmpty))
        {
            let alert = UIAlertController(title: "Invalid", message: "Please Enter all fields", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated:true, completion: nil)
        }
        else{
            PFUser.logInWithUsername(inBackground: email, password: password, block:{(user, error) -> Void in
                if error != nil{
                    let alert = UIAlertController(title: "Warning!", message: "Sorry, User Does'nt exists!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated:true, completion: nil)
                }
                else {
                    let alert:UIAlertController = UIAlertController(title: "Success", message: "successfully logged-in!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title:"OK", style: .default, handler: { action in self.performSegue(withIdentifier: "loginsuccess", sender: self)}))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
}
