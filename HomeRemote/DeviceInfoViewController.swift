//
//  DeviceInfoViewController.swift
//  HomeRemote
//
//  Created by Lucas McDonald on 3/27/17.
//  Copyright © 2017 Lucas McDonald. All rights reserved.
//

import Foundation
import UIKit

class DeviceInfoViewController: UIViewController {
    
    @IBOutlet weak var centeredNickname: UILabel!
    @IBOutlet weak var usernameField: UILabel!
    @IBOutlet weak var ipField: UILabel!
    @IBOutlet weak var passwordField: UILabel!
    @IBOutlet weak var nicknameField: UILabel!
    
    
    override func viewDidLoad() {
        //stuff
    }
    
    func processDeviceInfo(d: DeviceMO) {
        
        centeredNickname.text = d.nickname
        nicknameField.text = d.nickname
        usernameField.text = d.username
        passwordField.text = d.password
    }
    
}
