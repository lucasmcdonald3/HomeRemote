//
//  LoginViewController.swift
//  QRT
//
//  Class that controls the view of the login screen. Creates an SSH connection then hands it to the next view controller.
//
//  Created by Lucas McDonald on 7/22/16.
//  Copyright © 2016 Lucas McDonald.
//

import UIKit
import Foundation
import Firebase

class DeviceAddViewController: UIViewController {
    
    // dummy variable for class scopae
    var session = SSHConnection.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // call last successful login info for easier login
        
        // keyboard dismisser
        let keyboardHide: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DeviceAddViewController.keyboardHide))
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
    func saveDeviceInfo(){
        
        // store login info for next time
        
        //let userDefaults = UserDefaults.standard
        
        // switch view to MenuViewController
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let menu = storyBoard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        
        
        self.navigationController?.pushViewController(menu, animated: true)
        
    }
    
    func encodeDeviceArray(){
        
    }
    
    @IBAction func infoPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add a Device", message: "Add a device hub using its IP address, SSH username, and password. You can also give the device hub an easy-to-remember nickname. You must be able to connect to the device hub to add it to the list.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // called from passwordfield's go button
    @IBAction func loginFromGoKeyboard(_ sender: AnyObject) {
        saveDeviceInfo()
    }

    // called from the login button on the screen
    @IBAction func loginButton(_ sender: UIButton) {
        saveDeviceInfo()
    }
    
    // hides keyboard when tapping out of text field
    func keyboardHide() {
        view.endEditing(true)
    }
    
    @IBAction func AndrewNewButton(_ sender: UIButton) {
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
