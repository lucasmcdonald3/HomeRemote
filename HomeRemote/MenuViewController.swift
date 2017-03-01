//
//  MenuViewController.swift
//  
//
//  Created by Lucas McDonald on 2/25/17.
//
//

import Foundation
import UIKit


class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        projectsList.beginUpdates()
        
        // TODO: add project from firebase
        // insert new cell into table
        
        let newProj = Project.init(d: Device.init(u: "4u3", i: "43.43.4.3.1.4.3", p: "hunter2", n: "my device", d: "RPi"), remote: "stepper", pN: "my project", pD: "project description")
        
        projects.append(newProj)
        
        let userDefaults = UserDefaults.standard
        
        
        
        // create the device object and immediately encode it
        let encodedDeviceArray = NSKeyedArchiver.archivedData(withRootObject: projects)
        userDefaults.setValue(encodedDeviceArray, forKey: "storedProjects")
        
        userDefaults.synchronize()
        
        projectsList.insertRows(at: [IndexPath(row: projects.count-1, section: 0)], with: .automatic)
        projectsList.endUpdates()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register the table view cell class and its reuse id
        self.projectsList.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        projectsList.delegate = self
        projectsList.dataSource = self
        
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: "projects") != nil {
            projects = userDefaults.object(forKey: "projects") as! [Project]
        }
        
        if userDefaults.object(forKey: "devices") != nil {
            devices = userDefaults.object(forKey: "devices") as! [Device]
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
