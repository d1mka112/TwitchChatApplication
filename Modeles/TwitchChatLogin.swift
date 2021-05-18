//
//  TwitchChatLogin.swift
//  TwitchChatApplication
//
//  Created by Mac on 06.05.2021.
//

import Foundation

protocol TwitchChatLoginDelegate
{
    func OnMessage(_ data: Data)
}

//TODO semaphore!!!
class TwitchChatLogin {
    var mainUrlString = "https://id.twitch.tv/oauth2/authorize"
    
    let requestParameters: [String : String] = [
        "client_id" : "63xnlr28umdtqdi5sys8i15nkk87ot",
        "redirect_uri" : "https://localhost/",
        "response_type": "token",
        "scope" : "chat:read+chat:edit+channel:moderate+whispers:read+whispers:edit+channel_editor"
    ]
    var delegate: TwitchChatLoginDelegate?
    
    
    var data: Data
    
    init() {
        self.data = Data()
    }
    
    func getRequset () -> URLRequest {
        var parameters = "?"
        
        for key in requestParameters.keys {
            parameters += "\(key)=\(requestParameters[key]!)&"
        }
        
        let mainUrl = URL(string: mainUrlString+parameters)!

        var Request = URLRequest(url: mainUrl)
        
        Request.httpMethod = "GET"
        
        return Request
    }
    
    func oAuthRequest () {
        
        var parameters = "?"
        
        for key in requestParameters.keys {
            parameters += "\(key)=\(requestParameters[key]!)&"
        }
        
        guard let mainUrl = URL(string: mainUrlString+parameters)
        else {
            return
        }
        var Request = URLRequest(url: mainUrl)
        
        Request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: Request) { (data, response, error) in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            self.data = data
            self.delegate?.OnMessage(data)
        }

        task.resume()
        return
    }
    
}

/*
let twitchOAuth = TwitchChatLogin()
twitchOAuth.oAuthRequest()
*/
