//
//  Project.swift
//  HomeRemote
//
//  Created by Lucas McDonald on 2/25/17.
//  Copyright © 2017 Lucas McDonald.
//

import Foundation
import CoreData

class Project: NSObject {
    
    var device:Device!
    var remoteType:String!
    
    var projectName:String!
    var projectDescription:String!
    
    init(d: Device, remote: String, pN: String, pD: String) {
        super.init()
        device = d
        remoteType = remote
        
        projectName = pN
        projectDescription = pD
    }
    
    // swift why
    // what is the point of the below three
    override convenience init() {
        self.init(d: Device(), remote: "", pN: "Project", pD: "My Project")
    }
    
    convenience init(coder decoder: NSCoder) {
        self.init()
        device = decoder.decodeObject(forKey: "device") as! Device
        remoteType = decoder.decodeObject(forKey: "remoteType") as! String
        
        projectName = decoder.decodeObject(forKey: "projectName") as! String
        projectDescription = decoder.decodeObject(forKey: "projectDescription") as! String
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encode(device, forKey: "device")
        coder.encode(remoteType, forKey: "remoteType")
        
        coder.encode(projectName, forKey: "projectName")
        coder.encode(projectDescription, forKey: "projectDescription")
    }
    
}
