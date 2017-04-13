//
//  ProjectMenuViewController.swift
//
//  Provides a UITableView to display a list of registered projects.
//
//  Created by Lucas McDonald on 2/25/17.
//

import Foundation
import UIKit
import CoreData


class ProjectMenuViewController: ManagedObjectViewController {
    
    // Data / storage elements
    var secondLoad = false
    var projects: [ProjectMO] = []
    
    // UI elements
    @IBOutlet weak var projectsList: UITableView!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    
    /******************
       Setup Methods
    ******************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.abstractProjects = self.projects
        super.objectsList = self.projectsList
        
        // Register the table view cell class and its reuse id
        self.projectsList.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        projectsList.delegate = self
        projectsList.dataSource = self
        
        retrieveProjectList()
        populateProjectsView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewappppppppppprd")
        retrieveProjectList()
        updateProjectsView()
    }
    
    /******************
       Data Methods
    ******************/
    
    
    /**
     
     Saves the Project list from CoreData into an array for easier access/modification.
     
     **/
    
    
    /******************
        UI methods
    ******************/
    
    
    /**
 
     Fills the UITableView with formatted Strings.
 
    **/
    
    /**
 
     Called on ViewDidLoad; deals with changes in the project view if any were made without reloading the view.
 
    **/
    func updateProjectsView() {
        print("projects:" + String(projects.count))
        print("table:" + String(tableViewData.count))
        if(projects.count != tableViewData.count){
            self.projectsList.beginUpdates()
            self.tableViewData.append(projects[projects.count-1].projectName! + ": " + (projects[projects.count-1].deviceUsed?.nickname)!)
            self.projectsList.insertRows(at: [IndexPath(row: projectsList.numberOfRows(inSection: 0), section: 0)], with: .automatic)
            
            
            
            self.projectsList.endUpdates()
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
        cell.textLabel?.text = (projects[indexPath.row].deviceUsed?.nickname!)! + ": " + projects[indexPath.row].projectName!
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let project = projects[indexPath.row]
        let device = project.deviceUsed
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

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            context.delete(projects[indexPath.row])
            appDelegate.saveContext()
            
            projects.remove(at: indexPath.row)
            tableViewData.remove(at: indexPath.row)
            projectsList.reloadData()
        }
    }
    
    
}
