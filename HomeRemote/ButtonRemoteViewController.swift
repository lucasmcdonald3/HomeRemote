//
//  StepperRemoteViewController.swift
//  HomeRemote
//
//  Created by Lucas McDonald on 2/25/17.
//  Copyright © 2017 Lucas McDonald.
//

import Foundation
import UIKit

class ButtonRemoteViewController: UIViewController {
    
    var session = SSHConnection.init()
    
    @IBOutlet weak var remoteButton: UIButton!
    
    @IBAction func buttonPressed(_ sender: Any) {
        session.sendCommand("cd /home/pi/Home_Remote; python SSHtoHomeRemote.py 1 0 0 0 0")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}
