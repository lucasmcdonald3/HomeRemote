//
//  FirebaseDataViewController.swift
//  HomeRemote
//
//  Created by Lucas McDonald on 3/2/17.
//

import Foundation
import UIKit
import CoreData

class FirebaseDataViewController: UIViewController, writeValueBackDelegate {
    
    // UI elements
    var githubLink = ""          // stores the link to the project's GitHub page
    var titleData = ""           // stores data for the titleLabel UILabel
    var descriptionData = ""     // stores data for the descriptionText UITextView
    var authorData = ""          // stores data for the author of the project (currently not used in a UI element)
    var remoteTypeData = ""      // stores the type of remote used by the project
    
    @IBOutlet weak var scrollView: UIScrollView!  // UI element that allows scrolling; container UIView
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var githubButton: UIButton!
    
    // Storage / data elements
    var deviceUsed = ""          // stores the name of the device to be used by the project
    var devices : [DeviceMO] = []      // stores all of the devices used in the app (CoreData)
    var projects : [ProjectMO] = []    // stores all of the projects used in the app (CoreData)
    var session = SSHConnection.init()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Navigational elements
    var prevRef = ""             // stores the navigational depth of the previous node
    
    // setup
    override func viewDidLoad() {
        // branching based on previous VC
        if(self.deviceUsed == "") {    // if this is accessed from a navigational node
            print("data link:"  + githubLink)
            print("title label:" + titleData)
            titleLabel.text = titleData
            descriptionText.text = descriptionData
        } else { // if this is accessed after choosing a device to use with this project
            downloadToDevice()
            saveProjectToCoreData()
        }
        
    }
    
    //////////////////////
    ///  Data Methods  ///
    //////////////////////
    
    /**
 
    Saves project in CoreData.
 
    **/
    func saveProjectToCoreData() {
        // store information of new device
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let project = NSEntityDescription.insertNewObject(forEntityName: "Project", into: context) as! ProjectMO
        
        let index = devices.index(where: { (item) -> Bool in
            item.nickname == deviceUsed // test if this is the item you're looking for
        })
        
        let device = devices[index!]
        
        project.deviceUsed = device
        project.projectDescription = "Test description."
        project.projectName = "Test name"
        project.remoteType = "SingleButton"
        
        do {
            try context.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
        // show new view controller
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    /**
 
    Sends a command to the device (e.g. RPi3) to download the project from GitHub.
     
    **/
    func downloadToDevice() {
        
        let index = devices.index(where: { (item) -> Bool in
            item.nickname == deviceUsed // test if this is the item you're looking for
        })
        
        let device = devices[index!]
        
        session = SSHConnection.init(username: device.username!, ip: device.ip!, password: device.password!, connect: true)
        _ = session.sendCommandWithResponse("ls")
        
    }
    
    
    /*
            UI METHODS
                            */
    
    @IBAction func viewGithubPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: githubLink)!)
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
