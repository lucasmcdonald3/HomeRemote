//
//  ProjectAddViewController.swift
//  HomeRemote
//
//  Created by Lucas McDonald on 3/2/17.
//  Copyright © 2017 Lucas McDonald. All rights reserved.
//

import Foundation
import UIKit

class ProjectAddViewController: UIViewController {
    
    // UI elements
    @IBOutlet weak var projectNicknameField: UITextField!
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
    
    @IBAction func publicInfoButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Make Project Public", message: "The project will be sent in for approval to be visible to other users in the app. Please ensure that you have followed the proper guidelines for submission prior to making your project public. You will need to provide your contact email for us to contact you if your project is approved or has issues.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func projectInfoButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add Custom Project", message: "This allows you to add any project that you have created. You must provide a valid GitHub link. If the link is valid and you are having issues, check to make sure that you follow the proper project format.", preferredStyle: UIAlertControllerStyle.alert)
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
