//
//  DeviceAddViewController.swift
//  HomeRemote
//
//  Adds a device to the list of stored devices.
//
//  Created by Lucas McDonald.
//

import UIKit
import Foundation
import CoreData

class DeviceAddViewController: UIViewController {
    
    // Storage / Data elements
    var session = SSHConnection.init()    // dummy variable for class scope
    var deviceInt = 0
    var devices: [DeviceMO] = []          // list of devices
    
    // UI Elements
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var ipField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var nicknameField: UITextField!
    
    // Navigational elements
    var mode = "Add"                      // state the VC is loaded in (add is default, meaning add/save a device)
    
    
    /******************
       Setup Methods
    ******************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // if editing, pre-populate the fields for easier editing
        if (mode == "Edit"){
            updateFieldsFromDevice()
        }
        
        retrieveDeviceList()
        
        // load the keyboard dismisser
        let keyboardHide: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DeviceAddViewController.keyboardHide))
        view.addGestureRecognizer(keyboardHide)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        retrieveDeviceList()
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /******************
        Data Methods
    ******************/
    
    
    /**
 
     Saves the Device list from CoreData into an array for easier access/modification.
 
    **/
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

    /**
     
     Saves the device info into CoreData and pops the DeviceAddViewController.
     
     **/
    func saveDeviceInfo(){
        
        // branch between adding or editing a device
        if(mode == "Add"){
            // if any fields are empty
            if(ipField.text == "" || usernameField.text == "" || passwordField.text == "" || nicknameField.text == "") {
                let alert = UIAlertController(title: "Empty Field", message: "Please enter information into all fields.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            
            // if all fields have text
            } else {
                
                // initiate a connection to ensure the device can be connected to
                session = SSHConnection.init(username: usernameField.text!, ip: ipField.text!, password: passwordField.text!, connect: true)
                
                // if connected with a correct password
                if(session.checkAuthorization()) {
                    
                    // the connection isn't needed anymore, so close it
                    session.closeConnection()
                    
                    // store information of new device
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    let device = NSEntityDescription.insertNewObject(forEntityName: "Device", into: context) as! DeviceMO
                    device.deviceType = "RPi3" // default device
                    device.ip = ipField.text
                    device.username = usernameField.text
                    device.password = passwordField.text
                    device.nickname = nicknameField.text
                    
                    do {
                        try context.save()
                    } catch {
                        fatalError("Failure to save context: \(error)")
                    }
                    
                    // show DeviceMenuVC by popping
                    _ = self.navigationController?.popViewController(animated: true)
                }
                
                // if not connected or incorrect password
                else {
                    let alert = UIAlertController(title: "Failed to Connect", message: "Failed to connect to the device. Ensure the device is connected and all information is entered correctly. You must be able to connect to the device in order to add it to your list of devices.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        // if the VC is loaded in "Edit" mode
        } else if (mode == "Edit") {
            
            // save updated info into the device in the data stack
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
            
            // pop to previous VC
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    /******************
        UI methods
    ******************/
    
    
    /**
     
     Updates the UI based on info from the loaded device.
 
    **/
    func updateFieldsFromDevice() {
        
        let device = devices[deviceInt]
        
        ipField.text = device.ip
        usernameField.text = device.username
        passwordField.text = device.password
        nicknameField.text = device.nickname
        
    }
    
    @IBAction func usernameDisappear(_ sender: UITextField) {
        usernameField.resignFirstResponder()
    }
    
    @IBAction func ipDisappear(_ sender: UITextField) {
        ipField.resignFirstResponder()
    }
    
    @IBAction func passwordDisappear(_ sender: UITextField) {
        passwordField.resignFirstResponder()
    }
    
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
