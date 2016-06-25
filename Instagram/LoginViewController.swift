//
//  LoginViewController.swift
//  Instagram
//
//  Created by Devshi Mehrotra on 6/20/16.
//  Copyright © 2016 Devshi Mehrotra. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onSignIn(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(usernameField.text!, password: passwordField.text!) { (user: PFUser?, error: NSError?) -> Void in
            if user != nil  {
                print("you're logged in")
                self.performSegueWithIdentifier("loginSegue", sender: nil)
                print("segue")
            }
        }
    }
    
    @IBAction func onSignUp(sender: AnyObject) {
        let newuser = PFUser()
        
        newuser.username = usernameField.text
        newuser.password = passwordField.text
        
        newuser.signUpInBackgroundWithBlock{(success: Bool, error: NSError?) -> Void in
            if success {
                print("Yay, created a user!")
                self.performSegueWithIdentifier("signUpSegue", sender: nil)
            }
            else {
                print(error?.localizedDescription)
                if error?.code == 202 {
                    print("Username is taken")
                }
            }
        }
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
