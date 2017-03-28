//
//  DeviceInfoViewController.swift
//  HomeRemote
//
//  Created by Lucas McDonald on 3/27/17.
//  Copyright © 2017 Lucas McDonald. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DeviceInfoViewController: UIViewController {
    
    @IBOutlet weak var centeredNickname: UILabel!
    @IBOutlet weak var usernameField: UILabel!
    @IBOutlet weak var ipField: UILabel!
    @IBOutlet weak var passwordField: UILabel!
    @IBOutlet weak var nicknameField: UILabel!

    var deviceInt = 0
    var devices: [DeviceMO] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveDeviceList()
        
        processDeviceInfo()
    }
    
    func retrieveDeviceList() {
        
        let devicesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Device")
        
        do {
            devices = try context.fetch(devicesFetch) as! [DeviceMO]
        } catch {
            fatalError("Failed to fetch devices: \(error)")
        }
    }
    
    @IBAction func editPressed(_ sender: UIBarButtonItem) {
        let nextVC: DeviceAddViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DeviceAddViewController") as! DeviceAddViewController
        nextVC.mode = "Edit"
        nextVC.retrieveDeviceList()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    
    func processDeviceInfo() {
        
        let d = devices[deviceInt]
        
        centeredNickname.text = d.nickname
        nicknameField.text = d.nickname
        usernameField.text = d.username
        passwordField.text = d.password
        ipField.text = d.ip
    }
    
}
