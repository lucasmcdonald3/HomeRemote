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
import CoreData

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
    
    

    
    /**
     
     Saves the device info into NSUserDefaults and pushes the ProjectMenuViewController.
     
    */
    func saveDeviceInfo(){
        
        // call up the PMVC
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "DeviceMenuViewController") as! DeviceMenuViewController
        
        // store information of new device
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let device = NSEntityDescription.insertNewObject(forEntityName: "Device", into: context) as! DeviceMO
        device.deviceType = "RPi3"
        device.ip = ipField.text
        device.username = usernameField.text
        device.password = passwordField.text
        device.nickname = nicknameField.text
        
        do {
            try context.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
        // show new view controller
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    
    /*
            UI methods and fields follow.
                                                */
    
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
    @IBAction func userToPassword(_ sender: UITextField) {
        usernameField.resignFirstResponder()
        ipField.becomeFirstResponder()
    }
    
    // next button between ip field and password field
    @IBAction func ipToUser(_ sender: UITextField) {
        ipField.resignFirstResponder()
        passwordField.becomeFirstResponder()
    }
    
    @IBAction func passwordToNickname(_ sender: UITextField) {
        passwordField.resignFirstResponder()
        nicknameField.becomeFirstResponder()
    }

    
    // called from passwordfield's go button
    @IBAction func loginFromGoKeyboard(_ sender: AnyObject) {
        saveDeviceInfo()
    }

    // called from the add button on the screen
    @IBAction func loginButton(_ sender: UIButton) {
        saveDeviceInfo()
    }
    
    // hides keyboard when tapping out of text field
    func keyboardHide() {
        view.endEditing(true)
    }
    
    
}
