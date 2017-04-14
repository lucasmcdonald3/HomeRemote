//
//  DeviceInfoViewController.swift
//  HomeRemote
//
//  Created by Lucas McDonald on 3/27/17.
//

import Foundation
import UIKit
import CoreData

class DeviceInfoViewController: UIViewController {
    
    // Storage / data elements
    var deviceInt = 0
    var devices: [DeviceMO] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // UI elements
    @IBOutlet weak var centeredNickname: UILabel!
    @IBOutlet weak var usernameField: UILabel!
    @IBOutlet weak var ipField: UILabel!
    @IBOutlet weak var passwordField: UILabel!
    @IBOutlet weak var nicknameField: UILabel!

    /******************
       Setup Methods
    ******************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // load the device and update the view's fields accordingly
        retrieveDeviceList()
        processDeviceInfo()
    }
    
    
    /*******************
        Data Methods
    *******************/
    
    
    /**
     
     Gets the list of devices from CoreData and stores it in an array for easier access.
     
     */
    func retrieveDeviceList() {
        
        // get list of deviceMOs as CoreData
        let devicesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Device")
        
        // convert CoreData to an array
        do {
            devices = try context.fetch(devicesFetch) as! [DeviceMO]
        } catch {
            fatalError("Failed to fetch devices: \(error)")
        }
    }
    
    /**
 
     Processes the device and update's the view's fields' information
 
    */
    func processDeviceInfo() {
        
        // get the device requested
        let d = devices[deviceInt]
        
        // update all fields
        centeredNickname.text = d.nickname
        nicknameField.text = d.nickname
        usernameField.text = d.username
        passwordField.text = d.password
        ipField.text = d.ip
    }
    
    
    /*********************
         UI Methods
    *********************/
    
    @IBAction func editPressed(_ sender: UIBarButtonItem) {
        let nextVC: DeviceAddViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DeviceAddViewController") as! DeviceAddViewController
        nextVC.mode = "Edit"
        nextVC.deviceInt = self.deviceInt
        nextVC.retrieveDeviceList()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
