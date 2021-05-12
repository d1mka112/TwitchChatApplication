//
//  TwitchChatLogin.swift
//  TwitchChatApplication
//
//  Created by Mac on 06.05.2021.
//

import Foundation

//TODO semaphore!!!
class TwitchChatLogin {
    var mainUrlString = "https://id.twitch.tv/oauth2/authorize"
    
    let requestParameters: [String : String] = [
        "client_id" : "63xnlr28umdtqdi5sys8i15nkk87ot",
        "redirect_uri" : "https://localhost",
        "response_type": "token",
        "scope" : "chat:read+chat:edit+channel:moderate+whispers:read+whispers:edit+channel_editor"
    ]
    
    init() {

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
            print(String(data: data, encoding: .utf8)!)
        }

        task.resume()
        return
    }
    
}

/*
let twitchOAuth = TwitchChatLogin()
twitchOAuth.oAuthRequest()
*/
