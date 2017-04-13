//
//  ManagedObjectViewController.swift
//
//  Provides a UITableView to display a list of registered projects.
//
//  Created by Lucas McDonald on 2/25/17.
//

import Foundation
import UIKit
import CoreData


class ManagedObjectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Data / storage elements
    var tableViewData = [String]()         // array used to populate the UITableView with Strings
    let cellReuseIdentifier = "cell"
    var objectNumber = 0
    var session = SSHConnection.init()     // dummy variable used for class scope
    var abstractProjects: [ProjectMO] = []
    var abstratDevices: [DeviceMO] = []
    
    // CoreData shortcuts
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // UI elements
    @IBOutlet weak var objectsList: UITableView!
    
    /******************
       Setup Methods
    ******************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    /******************
        Data Methods
    ******************/
    
    
    /**
     
     Saves the Project list from CoreData into an array for easier access/modification.
     
     **/
    func retrieveProjectList() {
        
        let projectsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Project")
        
        do {
            abstractProjects = try context.fetch(projectsFetch) as! [ProjectMO]
        } catch {
            fatalError("Failed to fetch devices: \(error)")
        }
        
    }
    
    
    /**
     
     Saves the Device list from CoreData into an array for easier access/modification.
     
     **/
    func retrieveDeviceList() {
        
        let devicesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Project")
        
        do {
            abstractDevices = try context.fetch(devicesFetch) as! [DeviceMO]
        } catch {
            fatalError("Failed to fetch devices: \(error)")
        }
        
    }
    
    
    /******************
     UI methods
     ******************/
    
    
    /**
     
     Fills the UITableView with formatted Strings.
     
     **/
    func populateProjectsView() {
        print("populate called")
        self.objectsList.beginUpdates()
        var i = 0
        for project in abstractProjects {
            self.tableViewData.append(project.projectName! + ": " + (project.deviceUsed?.nickname)!)
            self.objectsList.insertRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
            i += 1
        }
        self.objectsList.endUpdates()
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    @IBAction func editPressed(_ sender: UIBarButtonItem) {
        objectsList.setEditing(!objectsList.isEditing, animated: true)
    }
}
