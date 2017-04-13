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
    var deviceFetched: DeviceMO? = nil
    
    // UI elements
    @IBOutlet weak var githubField: UITextField!
    @IBOutlet weak var publicSwitch: UISwitch!
    @IBOutlet weak var contactEmailField: UITextField!
    @IBOutlet weak var contactEmailLabel: UILabel!
    @IBOutlet weak var deviceButton: UIButton!
    
    
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
        
        // load the keyboard hider
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
        
        // if any fields are empty
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
            project.remoteType = "SingleButton"
            
            do {
                try context.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            
            // pop to ProjectMenuVC
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
    
    @IBAction func publicInfoButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Make Project Public", message: "The project will be sent in for approval to be visible to other users in the app. Please ensure that you have followed the proper guidelines for submission prior to making your project public. You will need to provide your email to let us contact you when your project is approved.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func projectInfoButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add Custom Project", message: "This allows you to add any project that you have created. The project will be downloaded from GitHub and configured on both your phone and your device when the button is pressed. You must provide a valid GitHub link. The project must conform to the proper guidelines to be interpreted in the app properly.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func deviceButtonPressed(_ sender: UIButton) {
        
        //push the DeviceMenuViewController and set it to the "select" option
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "DeviceMenuViewController") as! DeviceMenuViewController
        nextVC.delegate = self
        nextVC.mode = "addToProject"
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    @IBAction func addPressed(_ sender: UIButton) {
        saveProjectInfo()
    }
    
    
    @IBAction func switchTriggered(_ sender: Any) {
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.contactEmailField.alpha = 1.0 - self.contactEmailField.alpha
            self.contactEmailLabel.alpha = 1.0 - self.contactEmailLabel.alpha
            
        })
    }
    
    func writeValueBack(value: String, device: DeviceMO) {
        deviceButton.setTitle(value, for: .normal)
        deviceFetched = device
    }
    
    
    // hides keyboard when tapping out of text field
    func keyboardHide() {
        view.endEditing(true)
    }
    
}
