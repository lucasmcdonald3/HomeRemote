//
//  Device.swift
//  HomeRemote
//
//  Created by Lucas McDonald on 2/25/17.
//  Copyright © 2017 Lucas McDonald. All rights reserved.
//

import Foundation

class Device: NSObject {
    
    var username:String
    var ip:String
    var password:String
    var nickname:String
    var deviceType:String
    
    init(u: String, i: String, p: String, n: String, d: String){
        self.username = u
        self.ip = i
        self.password = p
        self.nickname = n
        self.deviceType = d
        super.init()
    }
    
    // what is the point of the below three methods
    convenience override init() {
        self.init(u: "", i: "", p: "", n: "", d: "")
    }
    
    convenience init(coder decoder: NSCoder) {
        self.init()
        self.username = decoder.decodeObject(forKey: "username") as! String
        self.ip = decoder.decodeObject(forKey: "ip") as! String
        self.password = decoder.decodeObject(forKey: "password") as! String
        self.nickname = decoder.decodeObject(forKey: "nickname") as! String
        self.deviceType = decoder.decodeObject(forKey: "deviceType") as! String
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encode(self.username, forKey: "username")
        coder.encode(self.ip, forKey: "ip")
        coder.encode(self.password, forKey: "password")
        coder.encode(self.nickname, forKey: "nickname")
        coder.encode(self.deviceType, forKey: "deviceType")
    }
    
    
}
