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
            getGithubInfo(indexPath: indexPath)
        }
    }
    
    
    /**
     
     Reads the PhoneInfo.json file and parses it to update UI elements in the FirebaseDataVC.
     
    **/
    func getGithubInfo(indexPath: IndexPath) {
        // get storyboard and instantiate next VC
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let detailVC = storyBoard.instantiateViewController(withIdentifier: "FirebaseDataViewController") as! FirebaseDataViewController
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
                
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                
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
    
    /**
    
     Gets the link to the PhoneInfo.json file from the GitHub link.
 
    **/
    func getPhoneInfoJsonLink(link: String) -> String {
        if let rangeOfCom = link.range(of: "com", options: .backwards) {
            var trimmedLink = String(link.characters.suffix(from: rangeOfCom.upperBound))
            trimmedLink = "https://raw.githubusercontent.com" + trimmedLink + "/master/PhoneInfo.json"
            return trimmedLink
        }
        else{
            print("oopsie")
            return "oop"
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
}
