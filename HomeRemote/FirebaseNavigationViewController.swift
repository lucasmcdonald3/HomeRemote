//
//  FirebaseNavigationVIewController.swift
//  HomeRemote
//
//  Created by Lucas McDonald on 2/25/17.
//  Copyright © 2017 Lucas McDonald. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class FirebaseNavigationViewController: UITableViewController {
    
    let cellReuseIdentifier = "cell"
    var devices = [String]()
    
    @IBOutlet var hubList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register the table view cell class and its reuse id
        self.hubList.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        hubList.delegate = self
        hubList.dataSource = self
        
        ////// SCRIPT ///////
        let storageRef = FIRStorage.storage().reference()
        let ctrlListJson = storageRef.child("_controllers.json")
        
        let MAX_FS = 16*1024 // tight limit for now
        
        devices = []
        
        ctrlListJson.data(withMaxSize: Int64(MAX_FS)) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print(error)
                // pop up some sort of message
                return;
            } else {
                let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                
                // get ist of controllers
                if let dictionary = json as? [String: Any] {
                    if let arr = dictionary["controllers"] as? [String] {
                        self.hubList.beginUpdates()
                        for i in 0...(arr.count-1) {
                            self.devices.append(arr[i])
                            self.hubList.insertRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
                        }
                        self.hubList.endUpdates()
                    }
                }
            }
        }
        
        
    }
    
    // create a cell for each table view row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = hubList.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        // set the text from the data model
        cell.textLabel?.text = devices[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    
    // method to run when table view cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let stepVC = storyBoard.instantiateViewController(withIdentifier: "FirebaseDeviceViewController") as! FirebaseDeviceViewController
        stepVC.hub = self.devices[indexPath.row]
        self.navigationController?.pushViewController(stepVC, animated: true)
    }
    
}
