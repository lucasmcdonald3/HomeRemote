//
//  ProjectAddViewController.swift
//  HomeRemote
//
//  Created by Lucas McDonald on 3/2/17.
//  Copyright © 2017 Lucas McDonald. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ProjectAddViewController: UIViewController {
    
    // UI elements
    @IBOutlet weak var githubField: UITextField!
    @IBOutlet weak var publicSwitch: UISwitch!
    @IBOutlet weak var contactEmailField: UITextField!
    @IBOutlet weak var contactEmailLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        publicSwitch.isOn = false
        
        // hide fields that should only be visible if the project is to be made public
        
        contactEmailLabel.alpha = 0
        contactEmailField.alpha = 0
    }
    
    func saveDeviceInfo(){
        
        if(githubField.text == "" || (publicSwitch.isOn && contactEmailField.text == "")) {
            let alert = UIAlertController(title: "Empty Field", message: "Please enter information into all fields.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            // store information of new device
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let project = NSEntityDescription.insertNewObject(forEntityName: "Project", into: context) as! ProjectMO
            
            project
            
            do {
                try context.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            
            // show new view controller
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func publicInfoButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Make Project Public", message: "The project will be sent in for approval to be visible to other users in the app. Please ensure that you have followed the proper guidelines for submission prior to making your project public. You will need to provide your contact email for us to contact you if your project is approved or has issues.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func projectInfoButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add Custom Project", message: "This allows you to add any project that you have created. You must provide a valid GitHub link. The project must conform to the proper guidelines to be interpreted in the app properly.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func switchTriggered(_ sender: Any) {
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.contactEmailField.alpha = 1.0 - self.contactEmailField.alpha
            self.contactEmailLabel.alpha = 1.0 - self.contactEmailLabel.alpha
            
        })
    }
    
    
    
    
}
