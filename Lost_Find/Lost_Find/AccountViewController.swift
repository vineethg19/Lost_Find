//
//  AccountViewController.swift
//  Lost_Find
//
//  Created by Gajula,Vineeth on 3/26/17.
//  Copyright © 2017 nwmsu. All rights reserved.
//

import UIKit
import Parse
import MessageUI

// To change users details: firstName, lastName and phoneNumber
class AccountViewController: UIViewController, MFMailComposeViewControllerDelegate {
    var email = ""
    var fname = ""
    var lname = ""
    var new_F = ""
    var new_L = ""
    var new_Phone = ""
    var check:Bool = false
    var user = ""
    var userID = ""
    var old_F = ""
    var old_L = ""
    
    @IBOutlet weak var welcomeMSG: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    // getting currently logged-in user details
    override func viewDidLoad() {
        super.viewDidLoad()
        let username = PFUser.current()
        userID = (username?.objectId!)!
        email = (username?.username)!
        welcomeLabel.text = "Logged in as \(self.email)"
    }
    
    // getting the user's first name and last name which displays at the top
    override func viewWillAppear(_ animated: Bool) {
        let userD = PFQuery(className: "_User")
        userD.whereKey("username", equalTo: self.email)
        userD.findObjectsInBackground { (objects:[PFObject]?, err: Error?) in
            for users in objects!
            {
                self.old_F =  (users["fname"] as! String?)!
                self.old_L = (users["lname"] as! String?)!
            }
            self.welcomeMSG.text = String("Welcome: \(self.old_F), \(self.old_L)")
        }
        
    }
    
    // sending user email and id to the UserDetailsEditViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userEdit"
        {
            let vc = segue.destination as! UserDetailsEditViewController
            vc.Sharedemail = self.email
            vc.objectId = self.userID
        }
    }
    
    // prompts user logout
    func myAlert(title:String, msg: String)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: {(action)in
            PFUser.logOut()
            alert.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "BacktoLogin", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: {(action)in
        }))
        self.present(alert, animated:true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // unwindSegue which sends updated user's firstname, lastname and phonenumber
    @IBAction func unwindFromUserDetails(segue: UIStoryboardSegue)
    {
        if let sourceVC = segue.source as? UserDetailsEditViewController
        {
            self.new_F = sourceVC.newF // first name which was edited
            self.new_L = sourceVC.newL   // last name from UDEVC
            self.new_Phone = sourceVC.newPhone // phone from UDEVC
            self.check = sourceVC.b
            self.user = sourceVC.email
        }
    }
    
    // displays mailUI where users can send email
    @IBAction func contactUs(_ sender: Any) {
        if MFMailComposeViewController.canSendMail()
        {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["lostfindteam@gmail.com"])
            mail.setSubject("Greetings!")
            mail.setMessageBody("<p>Hey, </p>", isHTML: true)
            self.present(mail, animated: true, completion: nil)
        }
    }
    
    // clicking cancel redirects to this view
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // logout alert showing a title and message
    @IBAction func logOut(_ sender: Any) {
        myAlert(title: "Are you sure?", msg: "you will again need to login to access the app.")
        
    }
    
}
