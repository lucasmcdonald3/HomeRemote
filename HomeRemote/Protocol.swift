//
//  Protocol.swift
//  
//  Protocol extended by MenuViewControllers.
//  Allows MenuVCs to be written to asynchronously.
//
//  Created by Lucas McDonald on 3/28/17.
//  Copyright © 2017 Lucas McDonald. All rights reserved.
//

import Foundation

protocol writeValueBackDelegate: NSObjectProtocol{
    func writeValueBack(value: String, device: DeviceMO)
}
