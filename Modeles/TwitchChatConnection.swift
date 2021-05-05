//
//  IRC.swift
//  TwitchChatApplication
//
//  Created by Mac on 24.04.2021.
//

import Foundation
/*TODO:
 - add onServerMessage()
 - add onChatMessage()
 - add onJoinChannel()
*/

protocol TwitchChatConnectionDelegate {
    func onChatMessage(_ message:String)
    func onJoinChannel(_ nameChannel:String)
}

//this structure will set all the values of its own properties from the raw data itself
struct TwitchChatMessage {
    var nickname: String
    var message: String
    var rawMessage: String
    
    init(rawMessage: String) {
        self.nickname = ""
        self.message = ""
        if let index = rawMessage.firstIndex(of: "!") {
            self.nickname = String(rawMessage.prefix(upTo: index).dropFirst())
        }
        if let index1 = rawMessage.firstIndex(of: "#") {
            if let index2 = rawMessage.suffix(from: index1).firstIndex(of: ":") {
                self.message = String(rawMessage.suffix(from: index2).dropFirst())
            }
        }
        self.rawMessage = rawMessage
    }
}

class TwitchChatConnection {
    
    var nickname: String = "d1mka112"
    var token: String = "oauth:vvdaqv83axufdgrp642d6z2ymg4apy"
    
    var channel: String = ""
    
    var willRead: Bool = false
    
    var delegate: TwitchChatConnectionDelegate?
    
    var webSocketTask = URLSession(configuration: .default).webSocketTask(with: URL(string: "wss://irc-ws.chat.twitch.tv:443")!)
    
    func sendMessage(_ message: String) {
        let urlMessage = URLSessionWebSocketTask.Message.string(message)
        webSocketTask.send(urlMessage) { error in
            if error != nil {
                print("WebSocket Couldn't send message \(error!)")
            }
        }
    }
    
    func connectToTheServer() {
        webSocketTask.resume()
        self.sendMessage("PASS \(token)")
        self.sendMessage("NICK \(nickname.lowercased())")
    }
    func connectToTheChatChannel(into channel: String) {
        self.sendMessage("JOIN #\(channel)")
    }
    
    func sendMessageToTheChat(_ message: String) {
        if channel != "" {
            self.sendMessage("PRIVMSG #\(channel) :\(message)")
        }
        else {
            print("You are not join to the channel!")
        }
    }
    
    func onServerMessage(_ message: String) {
        if(message.contains(":\(nickname).tmi.twitch.tv 366 \(nickname) #\(channel) :End of /NAMES list")) {
            delegate?.onJoinChannel(channel)
            //is that normal?
        }
        delegate?.onChatMessage(message)
    }
    
    func readMessage() {
        webSocketTask.receive { (result) in
            switch result {
                case .success(let urlMessage):
                    switch urlMessage {
                        case .string(let message):
                            //print(message)
                            self.onServerMessage(message)
                        default:
                            print("Error of reading message")
                            return
                    }
                case .failure(let error):
                    print(error)
            }
            if(self.willRead) {
                self.readMessage()
            }
        }
    }
}

class TwitchChatReader: TwitchChatConnectionDelegate {
    func onJoinChannel(_ nameChannel:String) {
        print("Joined to the channel \(nameChannel)")
    }
    
    func onChatMessage(_ message: String) {
        let msg = TwitchChatMessage(rawMessage: message)
        
        print("\(msg.nickname) : \(msg.message)")
    }
}


