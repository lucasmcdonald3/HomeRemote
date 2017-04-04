//
//  FirebaseDataViewController.swift
//  HomeRemote
//
//  Created by Lucas McDonald on 3/2/17.
//  Copyright © 2017 Lucas McDonald. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FirebaseDataViewController: UIViewController, writeValueBackDelegate {
    
    var prevRef = ""
    var githubLink = ""
    var titleData = ""
    var descriptionData = ""
    var authorData = ""
    var remoteTypeData = ""
    
    var deviceUsed = ""
    
    var devices : [DeviceMO] = []
    var projects : [ProjectMO] = []
    
    var session = SSHConnection.init()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var githubButton: UIButton!
    
    
    override func viewDidLoad() {
        if(self.deviceUsed == "") {
            print("data link:"  + githubLink)
            print("title label:" + titleData)
            titleLabel.text = titleData
            descriptionText.text = descriptionData
        } else {
            downloadToDevice()
        }
        
    }
    
    func downloadToDevice() {
        
        let index = devices.index(where: { (item) -> Bool in
            item.nickname == deviceUsed // test if this is the item you're looking for
        })
        
        let device = devices[index!]
        
        session = SSHConnection.init(username: device.username!, ip: device.ip!, password: device.password!, connect: true)
        _ = session.sendCommandWithResponse("ls")
        
        
        
        
        
    }
    
    
    
    @IBAction func viewGithubPressed(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: githubLink)!)
    }
    
    @IBAction func infoPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add Project", message: "This will add the project to your list of projects. The project will be downloaded from GitHub and configured on both your phone and your device when the button is pressed. You must be connected to the device the project will be used with in order to add the project.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addProjectPressed(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "DeviceMenuViewController") as! DeviceMenuViewController
        nextVC.delegate = self
        nextVC.mode = "addToProject"
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func retrieveProjectList() {
        
        let projectsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Project")
        
        do {
            projects = try context.fetch(projectsFetch) as! [ProjectMO]
        } catch {
            fatalError("Failed to fetch devices: \(error)")
        }
        
    }
    
    func retrieveDeviceList() {
        
        let devicesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Device")
        
        do {
            devices = try context.fetch(devicesFetch) as! [DeviceMO]
        } catch {
            fatalError("Failed to fetch devices: \(error)")
        }
        
    }
    
    func writeValueBack(value: String, device: DeviceMO) {
        
    }
    
    
}
