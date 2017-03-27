//
//  MenuViewController.swift
//  
//
//  Created by Lucas McDonald on 2/25/17.
//
//

import Foundation
import UIKit


class ProjectMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellReuseIdentifier = "cell"
    var projects = [Project]()
    var devices = [Device]()
    var objectNumber = 0
    var session = SSHConnection.init()
    
    @IBOutlet weak var projectsList: UITableView!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    
    @IBAction func editPressed(_ sender: UIBarButtonItem) {
        projectsList.setEditing(!projectsList.isEditing, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register the table view cell class and its reuse id
        self.projectsList.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        projectsList.delegate = self
        projectsList.dataSource = self
        
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: "projectList") != nil {
            projects = userDefaults.object(forKey: "projectList") as! [Project]
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = projectsList.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        // set the text from the data model
        cell.textLabel?.text = projects[indexPath.row].device.nickname + ": " + projects[indexPath.row].projectName
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let project = projects[indexPath.row]
        let device = project.device
        session = SSHConnection.init(username: (device?.username)!, ip: (device?.ip)!, password: (device?.password)!, connect: true)
        
        
        // ViewController being switched to
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        var remoteVC:RemoteViewController
        
        if(project.remoteType == "stepper"){
            remoteVC = storyBoard.instantiateViewController(withIdentifier: "StepperRemoteViewController") as! StepperRemoteViewController
        } else if(project.remoteType == "button"){
            remoteVC = storyBoard.instantiateViewController(withIdentifier: "ButtonRemoteViewController") as! ButtonRemoteViewController
        } else {
            remoteVC = storyBoard.instantiateViewController(withIdentifier: "ButtonRemoteViewController") as! ButtonRemoteViewController
        }
        
        // give SRVC the data it needs to reinitialize the ssh connection
        remoteVC.session = self.session
        //self.present(stepVC, animated:true, completion:nil)
        self.navigationController?.pushViewController(remoteVC, animated: true)
        
        
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            projects.remove(at: indexPath.row)
            projectsList.reloadData()
        }
    }
    
    
}
