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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func publicInfoButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Make Project Public", message: "The project will be sent in for approval to be visible to other users in the app. Please ensure that you have followed the proper guidelines for submission prior to making your project public. You will need to provide your contact email for us to contact you if your project is approved or has issues.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
}
