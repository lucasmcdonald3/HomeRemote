//
//  ProjectAddViewController.swift
//  HomeRemote
//
//  Adds a project to the list of stored projects.
//
//  Created by Lucas McDonald.
//

import UIKit
import Foundation
import CoreData

class ProjectAddViewController: UIViewController, writeValueBackDelegate {
    
    // Storage / Data elements
    var deviceFetched: DeviceMO? = nil                    // used to hold the device selected by the button
    
    // UI elements
    @IBOutlet weak var githubField: UITextField!          // contains a link to the project's Github
    @IBOutlet weak var publicSwitch: UISwitch!            // when on, the switch reveals fields to make a project public
    @IBOutlet weak var contactEmailField: UITextField!    // allows user to put a contact email to review their project
    @IBOutlet weak var contactEmailLabel: UILabel!
    @IBOutlet weak var deviceButton: UIButton!            // pressing allows user to select a device to use with project
    
    
    /******************
       Setup Methods
    ******************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // start the public switch in the off state
        publicSwitch.isOn = false
        
        // hide fields that should only be visible if the project is to be made public
        contactEmailLabel.alpha = 0
        contactEmailField.alpha = 0
        
        // load the keyboard dismisser
        let keyboardHide: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProjectAddViewController.keyboardHide))
        view.addGestureRecognizer(keyboardHide)
    }
    
    
    /******************
       Data Methods
    ******************/
    
    /**
 
     Saves the Project into a new project or an existing one, depending on the state of the view.
     
    **/
    func saveProjectInfo(){
        
        // if any fields are empty, tell the user to fill them out
        if(githubField.text == "" || (publicSwitch.isOn && contactEmailField.text == "") || deviceButton.currentTitle == "Select") {
            let alert = UIAlertController(title: "Empty Field", message: "Please enter information into all fields and select one of your currently registered devices.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        // if all fields are filled
        } else {
            
            // store information of new project
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let project = NSEntityDescription.insertNewObject(forEntityName: "Project", into: context) as! ProjectMO
            project.deviceUsed = deviceFetched
            project.projectDescription = "Test description."
            project.projectName = "Test name"
            project.remoteType = "Stepper"
            
            // save the edited CoreData
            do {
                try context.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            
            // pop to ProjectMenuVC (root)
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    
    /*
     
     Downloads info about the project (remote type, etc.) to the phone for storage.
     
     */
    func getInfoToPhone() {
        
    }
    
    /*
     
     Downloads the code for the device onto the device.
     
     */
    func downloadFileToDevice() {
        
    }
    
    /******************
        UI methods
    ******************/
    
    /// gives info on what happens when a project is made public
    @IBAction func publicInfoButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Make Project Public", message: "The project will be sent in for approval to be visible to other users in the app. Please ensure that you have followed the proper guidelines for submission prior to making your project public. You will need to provide your email to let us contact you when your project is approved.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    /// gives info on how to add a project
    @IBAction func projectInfoButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add Custom Project", message: "This allows you to add any project that you have created. The project will be downloaded from GitHub and configured on both your phone and your device when the button is pressed. You must provide a valid GitHub link. The project must conform to the proper guidelines to be interpreted in the app properly.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    /// pulls up a DeviceMenuVC to allow a user to select a device to use with the project
    @IBAction func deviceButtonPressed(_ sender: UIButton) {
        
        // load a DeviceMenuView
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "DeviceMenuViewController") as! DeviceMenuViewController
        
        // let the DeviceMenuVC write back to this view
        nextVC.delegate = self
        
        // let the DeviceMenuVC know that it is being used to store a device in a ProjectAddVC
        nextVC.mode = "addToProject"
        
        // push the DeviceMenuView
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    /// add project button
    @IBAction func addPressed(_ sender: UIButton) {
        saveProjectInfo()
    }
    
    /// called when the switch is pressed
    @IBAction func switchTriggered(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            // if the switch is visible, make it invisible. if it is invisible, make it visible.
            self.contactEmailField.alpha = 1.0 - self.contactEmailField.alpha
            self.contactEmailLabel.alpha = 1.0 - self.contactEmailLabel.alpha
        })
    }
    
    /// called when the view is written to
    func writeValueBack(value: String, device: DeviceMO) {
        deviceButton.setTitle(value, for: .normal)
        deviceFetched = device
    }
    
    
    /// hides keyboard when tapping out of text field
    func keyboardHide() {
        view.endEditing(true)
    }
    
}
