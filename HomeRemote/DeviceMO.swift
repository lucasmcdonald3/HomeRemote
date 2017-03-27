//
//  Device.swift
//  HomeRemote
//
//  Created by Lucas McDonald on 3/27/17.
//  Copyright © 2017 Lucas McDonald. All rights reserved.
//

import Foundation
import CoreData

class DeviceMO: NSManagedObject {
    
    @NSManaged var username: String?
    @NSManaged var password: String?
    @NSManaged var ip: String?
    @NSManaged var nickname: String?
    @NSManaged var deviceType: String?
    
    
}
