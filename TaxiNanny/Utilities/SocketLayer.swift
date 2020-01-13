//
//  SocketLayer.swift
//  Socket-Learning
//
//  Created by ip-d on 10/03/18.
//  Copyright © 2018 Esferasoft Solutions. All rights reserved.
//

import UIKit
import SocketIO

enum EventNotificationName:String
{
    case connected                          = "socket_event_connected"
    case disconnect                         = "socket_event_disconnect"
    case error                              = "socket_event_error"
    case callbackLoc                        = "socket_callbackLoc"
    
}

class SocketLayer: NSObject {
    
    static let shared = SocketLayer()
    private var socket:SocketIOClient!  =  nil
    
    private let manager = SocketManager(socketURL: URL.init(string:Constant.Socket_StreamURL)!, config:[.log(true),.compress])
    
    override init() {
        super.init()
    }
    
    func connect(_ forNamespace:String)
    {
        if socket != nil
        {
            if socket.status.active
            {
                socket.disconnect()
            }
            socket = nil
        }
        socket = manager.socket(forNamespace:forNamespace)
        socket.connect()
        setSocketEvents()
    }
    
    func reConnect()
    {
        if socket != nil
        {
            if !socket.status.active
            {
                socket.connect()
            }
        }
    }
    
    func disconnect()
    {
        if socket != nil && socket.status.active
        {
            socket.disconnect()
        }
    }
    
    func status() -> Bool {
        return socket.status.active
    }
    
    //Mark :- Observer function
    private func setSocketEvents()
    {
        socket.on(clientEvent:.connect) { (data, ack) in
            print("Socket Connnect")
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: EventNotificationName.connected.rawValue), object:nil, userInfo:nil)
        }
        
        socket.on(clientEvent:.disconnect) { (data, ack) in
            print("Socket Disconnnect")
        }
        
        socket.on(clientEvent: .error) { (data, ack) in
            print("Socket Error: \(data)")
            Utility.shared.showSnackBarMessage(message:"server cannot connect")
        }
        
        //Location: private
        socket.on("callbackLoc") { (data, ack) in
            print(data)
            
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: EventNotificationName.callbackLoc.rawValue), object:nil, userInfo:["response":data.first!])
        }
        
        //Driver
        socket.on("callbackDriver") { (data, ack) in
            print(data)
        } 
        //Status
        socket.on("callbackStatus") { (data, ack) in
            print(data)
        }
        
        //GetMsg
        socket.on("getMsg") { (data, ack) in
            print(data)
        }
        
    }
    
    //Mark :- emit funtions
    //updateLoc
    func updateLocation(parameter:NSDictionary)
    {
        print(parameter)
        self.socket.emitWithAck("updateLoc", with:[parameter]).timingOut(after: 10.0) { (acks) in
        }
    }
    
    //    updateStatus
    func updateStatus(Status:Int)
    {
        self.socket.emitWithAck("updateStatus", with:[Status]).timingOut(after: 10.0) { (acks) in
        }
    }
    
    //    sendMsg
    func sendMessage(message:String)
    {
        self.socket.emitWithAck("sendMsg", with:[message]).timingOut(after: 10.0) { (acks) in
        }
    }
    
}
