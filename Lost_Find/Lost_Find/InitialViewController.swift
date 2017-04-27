//
//  ViewController.swift
//  Lost_Find
//
//  Created by appleGeek on 3/18/17.
//  Copyright © 2017 nwmsu. All rights reserved.
//

import UIKit
import Parse

// initial View Controller which checks whether user still logged-in or not.
class InitialViewController: UIViewController {
    
    // executes only once after the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
    // executes the code asynchronously
        DispatchQueue.main.async {
            let mainstory:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let lvc: UIViewController = mainstory.instantiateViewController(withIdentifier: "loginviewcontroller")
            let fvc: UIViewController = mainstory.instantiateViewController(withIdentifier: "firstviewcontroller")
            let current = PFUser.current()
            if current != nil{
                self.present(fvc, animated: true, completion: nil)
            }
            else
            {
                self.present(lvc, animated: true, completion: nil)
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // used for memory warnings  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

