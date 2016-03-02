//
//  SignUpViewController.swift
//  PicPong
//
//  Created by Benson Huynh on 2016-02-24.
//  Copyright © 2016 Benson Huynh. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var countryField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpPressed(sender: AnyObject) {
        
        let username = self.usernameField.text
        let password = self.passwordField.text
        let country = self.countryField.text
        
        if password?.characters.count < 6 {
            let alert = UIAlertController(title: "Error", message: "Password must be greater than 6 characters", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "OK", style: .Default) { action in
                // Do nothing
            }
            alert.addAction(ok)
            presentViewController(alert, animated: true) {}
        } else {
            // Run a spinner to show a task in progress
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
            spinner.startAnimating()
            
            let newUser = Player()
            
            newUser.username = username
            newUser.password = password
            newUser.country = country!
            
            // Sign up the user asynchronously
            newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
                
                // Stop the spinner
                spinner.stopAnimating()
                if ((error) != nil) {
                    let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .Alert)
                    let ok = UIAlertAction(title: "OK", style: .Default) { action in
                    }
                    alert.addAction(ok)
                    self.presentViewController(alert, animated: true) {}
                } else {
                    
                    self.performSegueWithIdentifier("unwindToMainScreen", sender: nil)
                }
            })
        }
    }

}
