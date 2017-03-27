//
//  Project.swift
//  HomeRemote
//
//  Created by Lucas McDonald on 2/25/17.
//  Copyright © 2017 Lucas McDonald.
//

import Foundation
import CoreData

class Project {
    
    var device:Device!
    var remoteType:String!
    
    var projectName:String!
    var projectDescription:String!
    
    init(d: Device, remote: String, pN: String, pD: String) {
        device = d
        remoteType = remote
        
        projectName = pN
        projectDescription = pD
    }

    
}
