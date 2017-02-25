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
    var objects = [Project]()
    var objectNumber = 0
    
    @IBOutlet weak var projectsList: UITableView!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    
    @IBAction func editPressed(_ sender: UIBarButtonItem) {
        if(projectsList.isEditing){
            projectsList.setEditing(false, animated: true)
        } else {
            projectsList.setEditing(true, animated: true)
        }
    }
    
    @IBAction func searchPressed(_ sender: UIBarButtonItem) {
        projectsList.beginUpdates()
        
        // TODO: add project from firebase
        
        //insert new cell into table
        
        objects.append(Project.init(username: "No", ip: "Mebbe", password: "hunter2", remote: "hi"))
        
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(objects, forKey:"projects")
        
        userDefaults.synchronize()
        
        /*let indexPath = IndexPath(row: 0, section: 0)
        projectsList.insertRows(at: [indexPath], with: .automatic)
        projectsList.endUpdates()*/
        
        projectsList.insertRows(at: [IndexPath(row: objects.count-1, section: 0)], with: .automatic)
        projectsList.endUpdates()
    }
    
    
    
    @IBAction func settingsPressed(_ sender: UIBarButtonItem) {
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
            objects = userDefaults.object(forKey: "projects") as! [Project]
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = projectsList.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        // set the text from the data model
        cell.textLabel?.text = objects[indexPath.row].connectionUsername + ": " + objects[indexPath.row].projectName
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: GOTO remote
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            objects.remove(at: indexPath.row)
            projectsList.reloadData()
        }
    }
    
    
}
