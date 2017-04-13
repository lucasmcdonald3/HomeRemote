//
//  DeviceMenuViewController.swift
//
//  Provides a UITableView to display a list of registered devices.
//
//  Created by Lucas McDonald on 2/25/17.
//

import Foundation
import UIKit
import CoreData


class DeviceMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Storage / data elements
    var tableViewData = [String]()
    let cellReuseIdentifier = "cell"
    var objectNumber = 0
    var devices: [DeviceMO] = []
    var session = SSHConnection.init()
    var mode: String = "getDeviceInfo"
    weak var delegate: writeValueBackDelegate?
    // CoreData elements
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // UI elements
    @IBOutlet weak var deviceList: UITableView!

    
    /******************
       Setup Methods
    ******************/

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register the table view cell class and its reuse id
        self.deviceList.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        deviceList.delegate = self
        deviceList.dataSource = self
        
        // populate the table with devices from CoreData
        retrieveDeviceList()
        populateDeviceView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        retrieveDeviceList()
        updateDevicesView()
    }
    
    
    /*******************
        Data Methods
    *******************/
    
    
    /**
     
     Gets the list of devices from CoreData and stores it in an array for easier access.
     
     */
    func retrieveDeviceList() {

        // get list of projectMOs as CoreData
        let devicesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Device")
        
        // convert CoreData to an array
        do {
            devices = try context.fetch(devicesFetch) as! [DeviceMO]
        } catch {
            fatalError("Failed to fetch devices: \(error)")
        }
    }
    
    /**
     
     Updates the UITableView with elements from the projects array.
     
     */
    func populateDeviceView() {

        // tell the UITableView delegate to be ready to receieve changes
        self.deviceList.beginUpdates()
        
        // add each device to the UITableView's delegate
        for device in devices {
            
            // add the device's nickname
            self.tableViewData.append(device.nickname!)
            
            // let the UITableView know that its delegate has added an extra device
            self.deviceList.insertRows(at: [IndexPath(row: deviceList.numberOfRows(inSection: 0), section: 0)], with: .automatic)
        }
        
        // end update session for the UITableView, allowing it to update correctly
        self.deviceList.endUpdates()
    }
    
    
    /**
     
     Checks if there were any changes to the data since the view last loaded.
     If there are changes, update the list of devices accordingly.
     
     */
    func updateDevicesView() {
        
        /*  if the number of devices is greater than from the number of devices displayed
         i.e. if a device has been added                                              */
        if(devices.count > tableViewData.count){
            
            // tell the UITableView delegate to be ready to receieve changes
            self.deviceList.beginUpdates()
            
            // add the new device to the delegate
            self.tableViewData.append(devices[devices.count-1].nickname!)
            
            // let the UITableView know that its delegate has added an extra device
            self.deviceList.insertRows(at: [IndexPath(row: deviceList.numberOfRows(inSection: 0), section: 0)], with: .automatic)
            
            // end update session for the UITableView, allowing it to update correctly
            self.deviceList.endUpdates()
        }
    }

    /*********************
          UI Methods
    *********************/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = deviceList.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        // set the text from the data model
        cell.textLabel?.text = tableViewData[indexPath.row]
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(mode == "getDeviceInfo"){
            let nextVC: DeviceInfoViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DeviceInfoViewController") as! DeviceInfoViewController
            nextVC.deviceInt = indexPath.row
            print("nickname:" + self.devices[indexPath.row].nickname!)
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        } else if (mode == "addToProject") {
            delegate?.writeValueBack(value: self.devices[indexPath.row].nickname!, device: self.devices[indexPath.row])
            _ = self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete {
            
            context.delete(devices[indexPath.row])
            appDelegate.saveContext()
            
            devices.remove(at: indexPath.row)
            tableViewData.remove(at: indexPath.row)
            deviceList.reloadData()
            
            
        }
    }
    
    @IBAction func editPressed(_ sender: UIBarButtonItem) {
        deviceList.setEditing(!deviceList.isEditing, animated: true)
    }
    
    
}
