//
//  MenuViewController.swift
//
//
//  Created by Lucas McDonald on 2/25/17.
//
//

import Foundation
import UIKit
import CoreData


class DeviceMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var deviceList: UITableView!
    
    var tableViewData = [String]()
    let cellReuseIdentifier = "cell"
    var objectNumber = 0
    var devices: [DeviceMO] = []
    var session = SSHConnection.init()
    
    
    @IBAction func editPressed(_ sender: UIBarButtonItem) {
        deviceList.setEditing(!deviceList.isEditing, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register the table view cell class and its reuse id
        self.deviceList.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        deviceList.delegate = self
        deviceList.dataSource = self
        
        retrieveDeviceList()
        
        populateDeviceView()
        
    }
    
    func retrieveDeviceList() {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let devicesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Device")
        
        do {
            devices = try context.fetch(devicesFetch) as! [DeviceMO]
        } catch {
            fatalError("Failed to fetch devices: \(error)")
        }
    }
    
    func populateDeviceView() {
        print("populate called")
        self.deviceList.beginUpdates()
        var i = 0
        for device in devices {
            print(device.nickname ?? "Test")
            self.tableViewData.append(device.nickname!)
            self.deviceList.insertRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
            i += 1
        }
        self.deviceList.endUpdates()
    }
    
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
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "DeviceInfoViewController") as! DeviceInfoViewController
        print("nickname:" + self.devices[indexPath.row].nickname!)
        nextVC.centeredNickname.text = self.devices[indexPath.row].nickname
        self.navigationController?.pushViewController(nextVC, animated: true)
        
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            devices.remove(at: indexPath.row)
            deviceList.reloadData()
        }
    }
    
    
}
