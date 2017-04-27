//
//  PasswordEditViewController.swift
//  Lost_Find
//
//  Created by Gajula,Vineeth on 4/10/17.
//  Copyright © 2017 nwmsu. All rights reserved.
//

import UIKit
import Parse

// To reset the user's password
class PasswordEditViewController: UIViewController,UITextFieldDelegate {
    var pwd = ""
    var currentUser = ""
    
    @IBOutlet weak var cfmTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cfmTF.delegate = self
        pwdTF.delegate = self
    }
    
    // exits keyboard when touches outside the keyboard while editing    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Keyboard goes away after clicking return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pwdTF.resignFirstResponder()
        cfmTF.resignFirstResponder()
        return true
    }

    // reset the password with some validation to check length,empty fields and password matching etc.
    @IBAction func resetPassword(_ sender: Any) {
        if((self.pwdTF.text?.isEmpty)! || (self.cfmTF.text?.isEmpty)!)
        {
            let alert = UIAlertController(title: "Alert", message: "Please Entere All Fields!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated:true, completion: nil)
        }
        else if ((self.pwdTF.text?.characters.count)! < 8 ){
            let alert = UIAlertController(title: "Invalid", message: "Please enter a valid Password with atleast 8 characters", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated:true, completion: nil)
        }
            
        else if(self.pwdTF.text != self.cfmTF.text){
            let alert = UIAlertController(title: "Alert", message: "Password Doesn't Match!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated:true, completion: nil)
        }
        else
        {
            if  let currentUser = PFUser.current()
            {
                currentUser["password"] = self.pwdTF.text
                currentUser.saveInBackground()
            }
            let alert = UIAlertController(title: "Hurray", message: "Password changed successfully!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }   
}
