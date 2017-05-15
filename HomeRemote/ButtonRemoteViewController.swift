//
//  StepperRemoteViewController.swift
//  HomeRemote
//
//  Created by Lucas McDonald on 2/25/17.
//  Copyright © 2017 Lucas McDonald.
//

import Foundation
import UIKit

class ButtonRemoteViewController: RemoteViewController {
    
    @IBOutlet weak var remoteButton: UIButton!
    
    @IBAction func buttonPressed(_ sender: Any) {
        session.sendCommand("cd LEDController; python SSHtoHomeRemote.py")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}
