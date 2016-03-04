//
//  LogInViewController.swift
//  PicPong
//
//  Created by Benson Huynh on 2016-02-25.
//  Copyright © 2016 Benson Huynh. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class LogInViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    @IBAction func loginAction(sender: AnyObject) {
        let username = self.usernameField.text
        let password = self.passwordField.text
        
        if password?.characters.count < 5 {
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
            
            // Send a request to login
            Player.logInWithUsernameInBackground(username!, password: password!, block: { (user, error) -> Void in
                
                // Stop the spinner
                spinner.stopAnimating()
                
                if ((user) != nil) {
                    let alert = UIAlertController(title: "Success!", message: "Logged In", preferredStyle: .Alert)
                    let ok = UIAlertAction(title: "OK", style: .Default) { action in
                        self.performSegueWithIdentifier("segueToMainScreen", sender: nil)
                    }
                    alert.addAction(ok)
                    self.presentViewController(alert, animated: true) {}
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let viewController:UIViewController = UIStoryboard(name: "DesignSprint", bundle: nil).instantiateViewControllerWithIdentifier("LogInViewController") as! LogInViewController
                        self.presentViewController(viewController, animated: true, completion: nil)
                    })
                } else {
                }
            })
        }
    }
    
    override func viewDidLoad() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        hideTabBar()
//        setTabBarVisible(false, animated: true)
    }
    
    override func viewDidDisappear(animated: Bool) {
        showTabBar()
//        tabBarIsVisible()
    }
    
    func setTabBarVisible(visible: Bool, animated: Bool) {
        // hide tab bar
        let frame = self.tabBarController?.tabBar.frame
        let height = frame?.size.height
        let offsetY = (visible ? -height! : height)
        let duration:NSTimeInterval = (animated ? 0.0 : 0.0)
        if frame != nil {
            UIView.animateWithDuration(duration) {
                self.tabBarController?.tabBar.frame = CGRectOffset(frame!, 0, offsetY!)
                self.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height + offsetY!)
                self.view.setNeedsDisplay()
                self.view.layoutIfNeeded()
                return
            }
        }
    }
    
    func hideTabBar() {
        self.tabBarController?.tabBar.hidden = true
    }
    
    func showTabBar() {
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func unwindToLogInScreen(segue:UIStoryboardSegue) {
        
    }
}

