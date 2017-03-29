//
//  FirebaseNavigationVIewController.swift
//  HomeRemote
//
//  Created by Lucas McDonald on 2/25/17.
//  Copyright © 2017 Lucas McDonald. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class FirebaseNavigationViewController: UITableViewController {
    
    let cellReuseIdentifier = "cell"
    var tableViewData = [String]()
    var ref = FIRDatabase.database().reference().child("devices")
    var prevRef = ""
    var nodeDepth = 0
    
    @IBOutlet var tableViewList: UITableView!
    
    override func viewDidLoad() {
        
        // load table view stuff
        
        
        // Register the table view cell class and its reuse id
        self.tableViewList.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableViewList.delegate = self
        tableViewList.dataSource = self
        
        // check if there was a previous destination further than the "devices" node
        if prevRef != "" {
            ref = FIRDatabase.database().reference().child("devices").child(prevRef)
        }
        
        // populate table view with data from Firebase
        getFirebaseDatabase()
        
        super.viewDidLoad()
        
    }
    
    // create a cell for each table view row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = tableViewList.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        // set the text from the data model
        cell.textLabel?.text = tableViewData[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    
    
    // method to run when table view cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //if this is a navigational node, i.e. not a link to the GitHub files
        if(self.nodeDepth < 1) {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "FirebaseNavigationViewController") as! FirebaseNavigationViewController
            nextVC.prevRef = self.tableViewData[indexPath.row]
            nextVC.nodeDepth = self.nodeDepth + 1
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        
        // if this is NOT a navigational node, i.e. links to a GitHub file
        else {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let detailVC = storyBoard.instantiateViewController(withIdentifier: "FirebaseDataViewController") as! FirebaseDataViewController
            detailVC.prefRef = self.tableViewData[indexPath.row]
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let retrievedGithubLink = value?[self.tableViewData[indexPath.row]] as? String ?? ""
                print(retrievedGithubLink)
                detailVC.githubLink = retrievedGithubLink
            }) { (error) in
                print(error.localizedDescription)
            }
            
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        
    }
    
    // called to get the node's data from firebase
    func getFirebaseDatabase() {
        
        // get the base node
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.tableViewList.beginUpdates()
            
            // keeps track of current row. to be phased out
            var i = 0
            
            // loop over each child node
            for child in snapshot.children {
                
                // add each child node to the list of tableViewData
                self.tableViewData.append((child as! FIRDataSnapshot).key)
                
                // add each child node to the GUI
                self.tableViewList.insertRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
                i+=1
            }
            
            self.tableViewList.endUpdates()

        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
}
