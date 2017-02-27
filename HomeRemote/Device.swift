//
//  Device.swift
//  HomeRemote
//
//  Created by Lucas McDonald on 2/25/17.
//  Copyright © 2017 Lucas McDonald. All rights reserved.
//

import Foundation

class Device {
    
    var username:String
    var ip:String
    var password:String
    var nickname:String
    var deviceType:String
    
    init(u: String, i: String, p: String, n: String, d: String){
        username = u
        ip = i
        password = p
        nickname = n
        deviceType = d
    }
    
    // what is the point of the below three methods
    convenience init() {
        self.init(u: "", i: "", p: "", n: "", d: "")
    }
    
    convenience init(coder decoder: NSCoder) {
        self.init()
        username = decoder.decodeObject(forKey: "username") as! String
        ip = decoder.decodeObject(forKey: "ip") as! String
        
        password = decoder.decodeObject(forKey: "password") as! String
        nickname = decoder.decodeObject(forKey: "nickname") as! String
        deviceType = decoder.decodeObject(forKey: "deviceType") as! String
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encode(username, forKey: "username")
        coder.encode(ip, forKey: "ip")
        coder.encode(password, forKey: "password")
        coder.encode(nickname, forKey: "nickname")
        coder.encode(deviceType, forKey: "deviceType")
    }
    
    
}
