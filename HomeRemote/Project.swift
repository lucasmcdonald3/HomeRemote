//
//  Project.swift
//  HomeRemote
//
//  Created by Lucas McDonald on 2/25/17.
//  Copyright © 2017 Lucas McDonald. All rights reserved.
//

import Foundation

class Project {
    
    var device:Device
    
    var remoteType:String
    
    var projectName:String
    var projectDescription:String
    
    
    init(d: Device, remote: String) {
        device = d
        
        remoteType = remote
        
        projectName = ""
        projectDescription = ""
        
    }
    
}
