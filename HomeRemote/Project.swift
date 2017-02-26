//
//  Project.swift
//  HomeRemote
//
//  Created by Lucas McDonald on 2/25/17.
//  Copyright © 2017 Lucas McDonald. All rights reserved.
//

import Foundation

class Project {
    
    var device:Device!
    var remoteType:String!
    
    var projectName:String!
    var projectDescription:String!
    
    init(d: Device, remote: String) {
        device = d
        remoteType = remote
        
        projectName = ""
        projectDescription = ""
    }
    
    // swift why
    // what is the point of the below three
    convenience init() {
        self.init(d: Device(), remote: "")
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
