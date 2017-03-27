//
//  Device.swift
//  HomeRemote
//
//  Created by Lucas McDonald on 2/25/17.
//  Copyright © 2017 Lucas McDonald. All rights reserved.
//

import Foundation
import CoreData

class Device {
    
    @NSManaged var username:String?
    @NSManaged var ip:String?
    @NSManaged var password:String?
    @NSManaged var nickname:String?
    @NSManaged var deviceType:String?
    
    init(u: String, i: String, p: String, n: String, d: String){
        self.username = u
        self.ip = i
        self.password = p
        self.nickname = n
        self.deviceType = d
    }
    
}
