//
//  Project.swift
//  HomeRemote
//
//  Created by Lucas McDonald on 2/25/17.
//  Copyright © 2017 Lucas McDonald. All rights reserved.
//

import Foundation

class Project {
    
    var connectionUsername:String
    var connectionIP:String
    var connectionPassword:String
    
    var remoteType:String
    
    init(username: String, ip: String, password: String, remote: String) {
        connectionUsername = username
        connectionIP = ip
        connectionPassword = password
        remoteType = remote
    }
    
}
