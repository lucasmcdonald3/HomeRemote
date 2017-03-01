//
//  StepperRemoteViewController.swift
//  HomeRemote
//
//  Created by Lucas McDonald on 2/25/17.
//  Copyright © 2017 Lucas McDonald.
//

import Foundation
import UIKit

class StepperRemoteViewController: RemoteViewController {
    
    @IBOutlet weak var remoteTitle: UILabel!
    @IBOutlet weak var remoteData: UILabel!
    @IBOutlet weak var remoteButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    @IBAction func minusPressed(_ sender: UIButton) {
        let output = session.sendCommandWithResponse("cd /home/pi/Home_Remote; python SSHtoHomeRemote.py minus")
        remoteData.text = output
    }
    
    @IBAction func plusPressed(_ sender: UIButton) {
        let output = session.sendCommandWithResponse("cd /home/pi/Home_Remote; python SSHtoHomeRemote.py plus")
        remoteData.text = output
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        let output = session.sendCommandWithResponse("cd /home/pi/Home_Remote; python SSHtoHomeRemote.py function")
        remoteData.text = output
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}
