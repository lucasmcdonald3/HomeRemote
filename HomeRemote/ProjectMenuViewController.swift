//
//  ProjectMenuViewController.swift
//
//  Provides a UITableView to display a list of registered devices.
//
//  Created by Lucas McDonald on 2/25/17.
//

import Foundation
import UIKit
import CoreData


class ProjectMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Storage / data elements
    var tableViewData = [String]()        // array read by the UITableView
    let cellReuseIdentifier = "cell"
    var objectNumber = 0
    var session = SSHConnection.init()    // dummy initialization for class scope
    var projects: [ProjectMO] = []        // array projectMOs are held in
    var secondLoad = false                // to be used later (?)
    // CoreData elements
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        
        // Register the table view cell class and its reuse id
        self.projectsList.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        projectsList.delegate = self
        projectsList.dataSource = self
        
        // populate the table with projects from CoreData
        retrieveProjectList()
        //populateProjectsView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        retrieveProjectList()
        //updateProjectsView()
    }
    
    /*******************
        Data Methods
    *******************/
    
    
    /**
     
     Gets the list of projects from CoreData and stores it in an array for easier access.
     
    */
    func retrieveProjectList() {
        
        // get list of projectMOs as CoreData
        let projectsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Project")
        
        // convert CoreData to array
        do {
            projects = try context.fetch(projectsFetch) as! [ProjectMO]
        } catch {
            fatalError("Failed to fetch devices: \(error)")
        }
    }
    
    /**
     
     Updates the UITableView with elements from the projects array.
     
    */
    func populateProjectsView() {
        
        // tell the UITableView delegate to be ready to receieve changes
        self.projectsList.beginUpdates()
        
        self.tableViewData.removeAll()
        
        // add each project to the UITableView's delegate
        var i = 0
        for project in projects {
            
            // add the formatted String
            self.tableViewData.append(project.projectName! + ": " + (project.deviceUsed?.nickname)!)
            
            // let the UITableView know that its delegate has added an extra device
            print(projectsList.numberOfRows(inSection: 0))
            self.projectsList.insertRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
            i+=1
        }
        
        // end update session for the UITableView, allowing it to update correctly
        self.projectsList.endUpdates()
        
    }
    
    /**
 
     Checks if there were any changes to the data since the view last loaded.
     If there are changes, update the list of projects accordingly.
 
    */
    func updateProjectsView() {
        
        /*  if the number of projects is greater than from the number of projects displayed
            i.e. if a project has been added                                              */
        if(projects.count > tableViewData.count){
            
            // tell the UITableView delegate to be ready to receieve changes
            self.projectsList.beginUpdates()
            
            // add the new project to the delegate
            self.tableViewData.append(projects[projects.count-1].projectName! + ": " + (projects[projects.count-1].deviceUsed?.nickname)!)
            
            // let the UITableView know that its delegate has added an extra project
            self.projectsList.insertRows(at: [IndexPath(row: projectsList.numberOfRows(inSection: 0), section: 0)], with: .automatic)
            
            // end update session for the UITableView, allowing it to update correctly
            self.projectsList.endUpdates()
        }
    }
    
    /**
 
     Returns a class with the same name as the argument String
 
    */
    func stringClassFromString(_ className: String) -> AnyClass! {
        
        /// get namespace
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        
        /// get 'anyClass' with classname and namespace
        let cls: AnyClass = NSClassFromString("\(namespace).\(className)")!
        
        // return AnyClass!
        return cls
    }
    
    
    /*********************
          UI Methods
    *********************/
    
    // get the number of elements that should be in the tableView
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
        
        // get project and device from the tapped cell
        let project = projects[indexPath.row]
        let device = project.deviceUsed
        
        // instantiate connection
        session = SSHConnection.init(username: (device?.username)!, ip: (device?.ip)!, password: (device?.password)!, connect: true)
        
        // check if the device accepts the connection
        if session.checkAuthorization() {
            
            // ViewController being switched to
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            // instantiate generic RemoteViewController
            var remoteVC:RemoteViewController
            
            // cast the RemoteVC into the VC specified by the project
            remoteVC = storyBoard.instantiateViewController(withIdentifier: project.remoteType! + "RemoteViewController") as! RemoteViewController
            
            // give RemoteVC the data it needs to reinitialize the ssh connection
            remoteVC.session = self.session
            
            // push the RemoteVC
            self.navigationController?.pushViewController(remoteVC, animated: true)
        }
        
        // if the connection failed for some reason (incorrect login/ip info)
        else {
            let alert = UIAlertController(title: "Connection Failed", message: "We could not connect to the device. Please check your connection.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // allows editing of tableView
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // edit button
    @IBAction func editPressed(_ sender: UIBarButtonItem) {
        projectsList.setEditing(!projectsList.isEditing, animated: true)
    }
    
    // deleting element from table
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete {
            
            // remove from CoreData
            context.delete(projects[indexPath.row])
            
            // re-save CoreData
            appDelegate.saveContext()
            
            // remove from list of projects
            projects.remove(at: indexPath.row)
            
            // remove from tableViewData
            tableViewData.remove(at: indexPath.row)
            
            // reload table view
            projectsList.reloadData()
        }
    }
}
