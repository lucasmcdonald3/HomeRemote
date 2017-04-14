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
    
    // Storage / data elements
    var deviceUsed = ""                // stores the name of the device to be used by the project
    var devices : [DeviceMO] = []      // stores all of the devices used in the app (CoreData)
    var projects : [ProjectMO] = []    // stores all of the projects used in the app (CoreData)
    var session = SSHConnection.init()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // UI elements
    var githubLink = ""          // stores the link to the project's GitHub page
    var titleData = ""           // stores data for the titleLabel UILabel
    var descriptionData = ""     // stores data for the descriptionText UITextView
    var authorData = ""          // stores data for the author of the project (currently not used in a UI element)
    var remoteTypeData = ""      // stores the type of remote used by the project
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var githubButton: UIButton!
    
    
    // Navigational elements
    var prevRef = ""             // stores the navigational depth of the previous node
    
    
    /******************
       Setup Methods
    ******************/
    
    override func viewDidLoad() {
        
        // if accessed from navigational node
        if(self.deviceUsed == "") {
            
            // update the UI accordingly
            titleLabel.text = titleData
            descriptionText.text = descriptionData
            
        // if this is accessed after choosing a device to use with this project (not the first time loading)
        } else {
            
            // get the project loaded on the phone and the device. it's good to go!
            downloadToDevice()
            saveProjectToCoreData()
        }
    }
    
    
    /********************
        Data Methods
    ********************/
    
    
    /**
 
    Saves project in CoreData.
 
    */
    func saveProjectToCoreData() {
        
        // access CoreData stack
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // instantiate ProjectMO object to be edited and stored
        let project = NSEntityDescription.insertNewObject(forEntityName: "Project", into: context) as! ProjectMO
        
        // find the device that matches the given String
        let index = devices.index(where: { (item) -> Bool in
            item.nickname == deviceUsed
        })
        
        let device = devices[index!]
        
        // store each element into the created ProjectMO
        project.deviceUsed = device
        project.projectDescription = "Test description."
        project.projectName = "Test name"
        project.remoteType = "SingleButton"
        
        // save the ProjectMO object into CoreData
        do {
            try context.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
        // show root view controller (ProjectMenuVC)
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    /**
 
    Sends a command to the device (e.g. RPi3) to download the project from GitHub.
     
    */
    func downloadToDevice() {
        
        // get the device that corresponds with the name chosen
        let index = devices.index(where: { (item) -> Bool in
            item.nickname == deviceUsed
        })
        
        let device = devices[index!]
        
        // initiate connection to device
        session = SSHConnection.init(username: device.username!, ip: device.ip!, password: device.password!, connect: true)
        
        // send a shell command to download from Github
        _ = session.sendCommandWithResponse("ls")
        
    }
    
    
    /*******************
         UI Methods
    *******************/
    
    // called when the button to view the Github page is pressed
    @IBAction func viewGithubPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: githubLink)!)
    }
    
    // called by the info button. gives a background on how to add a project.
    @IBAction func infoPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add Project", message: "This will add the project to your list of projects. The project will be downloaded from GitHub and configured on both your phone and your device when the button is pressed. You must be connected to the device the project will be used with in order to add the project.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // called when the "add" button is pressed
    @IBAction func addProjectPressed(_ sender: Any) {
        
        // instantiate a DeviceMenuVC
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "DeviceMenuViewController") as! DeviceMenuViewController
        
        // let the DeviceMenuVC know to write data back to this
        nextVC.delegate = self
        
        // let the DeviceMenuVC know that, when a cell is tapped, it will write back to this view
        nextVC.mode = "addToProject"
        
        // push the DeviceMenuVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    /**
     
     Gets the list of projects from CoreData and stores it in an array for easier access.
     
     */
    func retrieveProjectList() {
        
        let projectsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Project")
        
        do {
            projects = try context.fetch(projectsFetch) as! [ProjectMO]
        } catch {
            fatalError("Failed to fetch devices: \(error)")
        }
        
    }
    
    /**
     
     Gets the list of devices from CoreData and stores it in an array for easier access.
     
     */
    func retrieveDeviceList() {
        
        let devicesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Device")
        
        do {
            devices = try context.fetch(devicesFetch) as! [DeviceMO]
        } catch {
            fatalError("Failed to fetch devices: \(error)")
        }
        
    }
    
    // unused for now
    func writeValueBack(value: String, device: DeviceMO) {
        
    }
    
    
}
