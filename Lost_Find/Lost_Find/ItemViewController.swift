//
//  ItemViewController.swift
//  Lost_Find
//
//  Created by appleGeek on 3/20/17.
//  Copyright © 2017 nwmsu. All rights reserved.
//

import UIKit
import Parse

// Class to display the item description
class ItemViewController: UIViewController {
    var object_id = ""
    var ID_IVC = ""
    var product_IVC = ""
    
    @IBOutlet weak var nameTF: UILabel!
    @IBOutlet weak var colorTF: UILabel!
    @IBOutlet weak var dateDisplay: UILabel!
    @IBOutlet weak var placeTF: UILabel!
    @IBOutlet weak var brandTF: UILabel!
    @IBOutlet weak var desc: UILabel!

    // loads the selected item while view appears
    override func viewWillAppear(_ animated: Bool) {
        loadReported()
    }
    
    // displays edit button at top-right which directs to another view controller where we can edit that item
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit, target: self, action: #selector(ItemViewController.edit_item))
    }
    
    // function which performs segue to itemEditViewController
    func edit_item()
    {
        self.performSegue(withIdentifier: "test", sender: self)
        
    }
    
    // sending objectId of the selected item when segue performs
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "test"
        {
            let vc = segue.destination as! ItemEditViewController
            vc.object_id = object_id //objectid
        }
    }
    
    // for handling memory
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // loads the item
    func loadReported()
    {
        let userQuery = PFQuery(className: "report")
        userQuery.findObjectsInBackground { (result:[PFObject]?, error:Error?) in
            if error == nil
            {
                for object in result!
                {
                    self.ID_IVC = object.value(forKey: "objectId") as! String
                    if (self.ID_IVC == self.object_id)
                    {
                        self.nameTF.text = object.value(forKey: "pname") as! String?
                        self.colorTF.text = object.value(forKey: "color") as! String?
                        self.desc.text = object["description"] as? String // accessing in different way as desc is of type dictionary
                        let state = object["state"] as! String // same as above
                        let city = object.value(forKey: "city") as! String
                        self.placeTF.text = String("\(city), \(state)")!  // "City, State" format for placeTF
                        self.dateDisplay.text = object.value(forKey: "date") as! String?
                        self.brandTF.text = object.value(forKey: "bname") as! String?
                    }
                }
            }
            else
            {
                print(error!)
            }
        } // query ends
    } // func ends
} // class ends
