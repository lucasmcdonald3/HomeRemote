//
//  FirebaseNavigationVIewController.swift
//  HomeRemote
//
//  Controls the Navigation VC through the Firebase JSON.
//
//  Created by Lucas McDonald on 2/25/17.
//

import UIKit
import Foundation
import Firebase

class FirebaseNavigationViewController: UITableViewController {
    
    // UI elements
    let cellReuseIdentifier = "cell"
    var tableViewData = [String]()
    @IBOutlet var tableViewList: UITableView!
    
    // Navigational elements
    var ref = FIRDatabase.database().reference().child("devices")
    var prevRef = ""
    var nodeDepth = 0
    
    /******************
       Setup Methods
    ******************/
    
    override func viewDidLoad() {
        
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
    
    
    
    /*******************
        Data Methods
    *******************/
    
    /**
     
     Reads the PhoneInfo.json file and parses it to update UI elements in the FirebaseDataVC.
     
     **/
    func getGithubInfo(indexPath: IndexPath) {
        // get storyboard and instantiate next VC
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let detailVC = storyBoard.instantiateViewController(withIdentifier: "FirebaseDataViewController") as! FirebaseDataViewController
        
        // set the nextVC's previous node as this node
        detailVC.prevRef = self.tableViewData[indexPath.row]
        
        // access the data from Firebase
        self.ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            // initialize dictionary to store accessed JSON
            let value = snapshot.value as? NSDictionary
            
            // get link to Github project
            var retrievedGithubLink = value?[self.tableViewData[indexPath.row]] as? String ?? ""
            detailVC.githubLink = retrievedGithubLink
            
            // initiate URL request to directly access PhoneInfo.json
            let requestURL: NSURL = NSURL(string: self.getPhoneInfoJsonLink(link: retrievedGithubLink))!
            let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
            let session = URLSession.shared
            
            // initiate asynchronous task to update UI accordingly
            let task = session.dataTask(with: urlRequest as URLRequest) {
                (data, response, error) -> Void in
                
                // find out the status of the URL request
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                // if the request was successful
                if (statusCode == 200) {
                    do{
                        // parse and restore the JSON
                        let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String: Any]
                        
                        // store each respective UI element in the DetailVC
                        if let fetchedTitle = json["Title"] as? String {
                            detailVC.titleData = fetchedTitle
                            print(fetchedTitle)
                        }
                        if let fetchedDescription = json["Description"] as? String {
                            detailVC.descriptionData = fetchedDescription
                            print(fetchedDescription)
                        }
                        if let fetchedAuthor = json["Author"] as? String {
                            detailVC.authorData = fetchedAuthor
                            print(fetchedAuthor)
                        }
                        if let fetchedRemote = json["Remote Type"] as? String {
                            detailVC.remoteTypeData = fetchedRemote
                            print(fetchedRemote)
                        }
                    } catch {
                        print("Error with Json: \(error)")
                    }
                }
            }
            
            // execute async task
            task.resume()
            
            // TEMPORARY FIX. Fixed delay to allow time for the asynchronous task to complete.
            usleep(30000)
            
            // present the detailVC
            self.navigationController?.show(detailVC, sender: self)
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    /**
 
     Called to get JSON info from this node from Firebase.
 
    */
    func getFirebaseDatabase() {
        
        // access data from this node
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            // let the tableView know to prepare to receive updates
            self.tableViewList.beginUpdates()
            
            // loop over each child node
            for child in snapshot.children {
                
                // add each child node to the list of tableViewData
                self.tableViewData.append((child as! FIRDataSnapshot).key)
                
                // add each child node to the tableView
                self.tableViewList.insertRows(at: [IndexPath(row: self.tableViewList.numberOfRows(inSection: 0), section: 0)], with: .automatic)
            }
            
            // let the tableView know that updates are completed
            self.tableViewList.endUpdates()
            
        // error handling
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    /******************
        UI Methods
    ******************/

    // method to run when table view cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //if this is a navigational node, i.e. not a link to the GitHub files
        if(self.nodeDepth < 1) {
            
            // instantiate a FirebaseNavigationVC as the next node in the navigational hierarchy
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "FirebaseNavigationViewController") as! FirebaseNavigationViewController
            
            // set this node as the previous node of the nextVC
            nextVC.prevRef = self.tableViewData[indexPath.row]
            
            // increment the next node's depth
            nextVC.nodeDepth = self.nodeDepth + 1
            
            // push the nextVC
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
            
        // if this is NOT a navigational node, i.e. contains a Github link
        else {
            getGithubInfo(indexPath: indexPath)
        }
    }
    
    /**
    
     Gets the link to the PhoneInfo.json file from the GitHub link.
 
    **/
    func getPhoneInfoJsonLink(link: String) -> String {
        
        // find the index of ".com" starting at the end
        if let rangeOfCom = link.range(of: "com", options: .backwards) {
            
            // trim the link to link directly to the PhoneInfo.json.
            // requires that the PhoneInfo.json is at the root (as specified for developers).
            var trimmedLink = String(link.characters.suffix(from: rangeOfCom.upperBound))
            trimmedLink = "https://raw.githubusercontent.com" + trimmedLink + "/master/PhoneInfo.json"
            
            // return this link
            return trimmedLink
        }
        // will likely only screw up if the link has not finished loading from Firebase/Github
        else {
            print("oopsie")
            return "oops"
        }
    }
    
    // create a cell for each table view row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = tableViewList.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        // set the text from the data model
        cell.textLabel?.text = tableViewData[indexPath.row]
        
        return cell
    }
    
    // number of elements in the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
}
