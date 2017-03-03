//
//  MenuViewController.swift
//
//
//  Created by Lucas McDonald on 2/25/17.
//
//

import Foundation
import UIKit


class DeviceMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var deviceList: UITableView!
    
    
    let cellReuseIdentifier = "cell"
    var projects = [Project]()
    var devices = [Device]()
    var objectNumber = 0
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
        
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: "projects") != nil {
            projects = userDefaults.object(forKey: "projects") as! [Project]
        }
        
        if userDefaults.object(forKey: "devices") != nil {
            devices = userDefaults.object(forKey: "devices") as! [Device]
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = deviceList.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        // set the text from the data model
        cell.textLabel?.text = devices[indexPath.row].nickname
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // TODO: Display information about device. IP, username, projects used in
        
        
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
