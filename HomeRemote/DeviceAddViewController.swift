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
    
    // dummy variable for class scope
    var session = SSHConnection.init()
    var mode = "Add"
    var deviceInt = 0
    var devices: [DeviceMO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (mode == "Edit"){
            updateFieldsFromDevice()
        }
        
        // keyboard dismisser
        let keyboardHide: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DeviceAddViewController.keyboardHide))
        view.addGestureRecognizer(keyboardHide)
        
        retrieveDeviceList()
        
        print(devices.count)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        retrieveDeviceList()
    }
        
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrieveDeviceList() {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let devicesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Device")
        
        do {
            devices = try context.fetch(devicesFetch) as! [DeviceMO]
            print(devices.count)
        } catch {
            fatalError("Failed to fetch devices: \(error)")
        }
        
        print(devices.count)
    }
    
    func updateFieldsFromDevice() {
        
        print(devices.count)
        
        let device = devices[deviceInt]
        
        ipField.text = device.ip
        usernameField.text = device.username
        passwordField.text = device.password
        nicknameField.text = device.nickname
        
    }

    
    /**
     
     Saves the device info into NSUserDefaults and pushes the ProjectMenuViewController.
     
     */
    func saveDeviceInfo(){
        if(mode == "Add"){
            if(ipField.text == "" || usernameField.text == "" || passwordField.text == "" || nicknameField.text == "") {
                let alert = UIAlertController(title: "Empty Field", message: "Please enter information into all fields.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                
                session = SSHConnection.init(username: usernameField.text!, ip: ipField.text!, password: passwordField.text!, connect: true)
                
                if(session.checkAuthorization()) {
                    
                    session.closeConnection()
                    
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
                    _ = self.navigationController?.popViewController(animated: true)
                }
                
                else {
                    let alert = UIAlertController(title: "Failed to Connect", message: "Failed to connect to the device. Ensure the device is connected and all information is entered correctly. You must be able to connect to the device in order to add it to your list of devices.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else if (mode == "Edit") {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            devices[deviceInt].ip = ipField.text
            devices[deviceInt].username = usernameField.text
            devices[deviceInt].password = passwordField.text
            devices[deviceInt].nickname = nicknameField.text
            
            do {
                try context.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            _ = self.navigationController?.popViewController(animated: true)
        }
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
