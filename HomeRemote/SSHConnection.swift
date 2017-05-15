//
//  SSHConnection.swift
//  QRT
//
//  Class that adds a bit more utility to the NMSSH framework.
//  Also personalizes the framework to make it more useful for HomeRemote.
//
//  Created by Lucas McDonald on 7/23/16.
//  Copyright © 2016 Lucas McDonald.
//

import Foundation
import UIKit
import NMSSH

class SSHConnection {
    
    // dummy NMsession for class scope
    var NMsession = NMSSHSession(host: "", andUsername: "")
    
    // data fields for logging in to SSH session
    var username = ""
    var ip = ""
    var password = ""
    
    /**
 
     Attempt to start an SSH session from the given information.
     
     - username: Username of the SSH session
     - ip: IP of the SSH session (including port)
     - password: Password of the SSH session
     - connect: if true, the session will attempt to connect as soon as it is constructed
 
    */
    init (username: String, ip: String, password: String, connect: Bool) {
        
        // store data for access
        self.username = username
        self.ip = ip
        self.password = password
        
        // define and connect to session
        self.NMsession = NMSSHSession(host: self.ip, andUsername: self.username)
        
        // attempt connection if connect is true
        if connect == true {
            NMsession?.connect()
            
            // if connection was successful, ensure the password is correct
            if (self.checkConnection()) {
                NMsession?.authenticate(byPassword: self.password)
            }
        }
    }
    
    /// constructor for dummy variables for class scope
    init () {
        NMsession = NMSSHSession(host: "", andUsername: "")
    }
    
    /// reconnect to the session; currently unused
    func reconnect(){
        
        // redefine the session
        NMsession = NMSSHSession(host: self.ip, andUsername: self.username)
        
        // reconnect to the session
        NMsession?.connect()
        
        // reauthenticate the session
        NMsession?.authenticate(byPassword: self.password)
    }
    
    /// check if the connection's username and IP are correct
    func checkConnection() -> Bool {
        //cases for handling login errors/successes. to be expanded on later.
        return NMsession!.isConnected
    }
    
    /// check if the connection's password is correct
    func checkAuthorization() -> Bool {
        return NMsession!.isAuthorized
    }
    
    /// send an SSH command; print output, but otherwise essentially ignore the output
    func sendCommand(_ command: String) {
        if self.checkAuthorization() {
            let errorOut:NSErrorPointer = nil
            print(NMsession?.channel.execute(command, error: errorOut, timeout: 2)! as Any)
        }
    }
    
    /// send SSH command; return the response as a String
    func sendCommandWithResponse(_ command: String) -> String {
        var message = "none"
        if self.checkConnection() {
            let errorOut:NSErrorPointer = nil
            message = (NMsession?.channel.execute(command, error: errorOut, timeout: 5))!
        }
        print(message)
        return message
    }
    
    /// resets the connection (if a command runs too long, timed checks to see if connection has changed, etc.)
    /// may be used to support background multitasking in the future
    func resetConnection(){
        NMsession?.disconnect()
        NMsession?.connect()
    }
    
    /// disconnect from session
    func closeConnection() {
        NMsession?.disconnect()
    }


    
}
