//
//  LoginViewController.swift
//  QRT
//
//  Class that controls the view of the login screen. Creates an SSH connection then hands it to the next view controller.
//
//  Created by Lucas McDonald on 7/22/16.
//  Copyright © 2016 Lucas McDonald. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class LoginViewController: UIViewController {
    
    // dummy variable for class scopae
    var session = SSHConnection.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // call last successful login info for easier login
        let userDefaults = UserDefaults.standard
        if !(userDefaults.value(forKey: "userKey") == nil) {
            usernameField.text = userDefaults.string(forKey: "userKey")
            ipField.text = userDefaults.string(forKey: "ipKey")
            passwordField.text = userDefaults.string(forKey: "passKey")
            
        }
        
        // keyboard dismisser
        let keyboardHide: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.keyboardHide))
        view.addGestureRecognizer(keyboardHide)
    }
        
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBAction func usernameDisappear(_ sender: UITextField) {
        usernameField.resignFirstResponder()
    }
    
    @IBOutlet weak var ipField: UITextField!
    
    @IBAction func ipDisappear(_ sender: UITextField) {
        ipField.resignFirstResponder()
    }
    
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBAction func passwordDisappear(_ sender: UITextField) {
        passwordField.resignFirstResponder()
    }
    
    @IBOutlet weak var nicknameField: UITextField!
    
    @IBAction func nicknameDisappear(_ sender: Any) {
        nicknameField.resignFirstResponder()
    }
    
    // next button between username field and ip field
    @IBAction func userToIP(_ sender: UITextField) {
        usernameField.resignFirstResponder()
        ipField.becomeFirstResponder()
    }
    
    // next button between ip field and password field
    @IBAction func ipToPassword(_ sender: UITextField) {
        ipField.resignFirstResponder()
        passwordField.becomeFirstResponder()
    }
    
    @IBAction func passwordToNickname(_ sender: UITextField) {
        passwordField.resignFirstResponder()
        nicknameField.becomeFirstResponder()
    }

    
    // called when the user attempts to login with the entered information
    func attemptLogin(){
        
        // initializes session with new info
        session = SSHConnection.init(username: usernameField.text!, ip: ipField.text!, password: passwordField.text!, connect: true)
        
        // checks if connection was successful
        if session.checkConnection(){
            //checks if password authentication was successful
            if session.checkAuthorization() {
                
                // store login info for next time
                let userDefaults = UserDefaults.standard
                userDefaults.setValue(usernameField.text, forKey: "userKey")
                userDefaults.setValue(ipField.text, forKey: "ipKey")
                userDefaults.setValue(passwordField.text, forKey: "passKey")
                userDefaults.synchronize()
                
                // switch view to MenuViewController
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let menu = storyBoard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
                menu.devices.append(Device.init(u: self.usernameField.text!, i: self.ipField.text!, p: self.passwordField.text!, n: self.nicknameField.text!))
                
                

                self.present(menu, animated:true, completion:nil)
                

            } else {
                // case for correct login information but incorrect password
                let alert = UIAlertController(title: "Incorrect Password", message: "Connected to the device properly, but with an incorrect password.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            // case for incorrect login information
            let alert = UIAlertController(title: "Connection Failed", message: "Failed to connect to the device. Your username/IP may be wrong or the device may be offline.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func infoPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add a Device", message: "Add a device using its SSH username, IP, and password. You can also give the device an easy-to-remember nickname. You must be able to connect to your device to add it to your list of devices.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // called from passwordfield's go button
    @IBAction func loginFromGoKeyboard(_ sender: AnyObject) {
        attemptLogin()
    }

    // called from the login button on the screen
    @IBAction func loginButton(_ sender: UIButton) {
        attemptLogin()
    }
    
    // hides keyboard when tapping out of text field
    func keyboardHide() {
        view.endEditing(true)
    }
    @IBAction func AndrewButton(_ sender: UIButton) {
        // Get a reference to the storage service using the default Firebase App
        
        // Get a reference to the storage service using the default Firebase App
        let storage = FIRStorage.storage()
        
        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        
        let ctrlJson = storageRef.child("_controllers.json")
        
        let ONE_MiB = 1024*1024 // will any
        
        var controllers: [Any]
        controllers = []
        
        ctrlJson.data(withMaxSize: Int64(ONE_MiB)) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print(error)
                // pop up some sort of message
                return;
            } else {
                let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                
                if let dictionary = json as? [String: Any] {
                    if let arr = dictionary["controllers"] as? [String] {
                        controllers = arr
                        print(controllers)
                    }
                }
            }
        }
    }
}
