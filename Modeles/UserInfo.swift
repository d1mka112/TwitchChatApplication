//
//  UserInfo.swift
//  TwitchChatApplication
//
//  Created by Mac on 19.05.2021.
//

import Foundation

/*
    "_id": 44322889,
     "bio": "Just a gamer playing games and chatting. :)",
     "created_at": "2013-06-03T19:12:02Z",
     "display_name": "dallas",
     "email": "email-address@provider.com",
     "email_verified": true,
     "logo": "https://static-cdn.jtvnw.net/jtv_user_pictures/dallas-profile_image-1a2c906ee2c35f12-300x300.png",
     "name": "dallas",
     "notifications": {
         "email": false,
         "push": true
     },
     "partnered": false,
     "twitter_connected": false,
     "type": "staff",
     "updated_at": "2016-12-14T01:01:44Z"
 */

struct UserInfo: Decodable {
    var id: String
    var bio: String?
    var createdAt: String?
    var displayName: String
    var email: String?
    var emailVerified: Bool?
    var logo: String?
    var name: String
    var notifications: Notifications?
    var partnered: Bool?
    var twitterConnected: Bool?
    var type: String?
    var updatedAt: String?
    
    //Also we can replace this decision to the keyDecodingStrategy 
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case bio
        case createdAt = "created_at"
        case displayName = "display_name"
        case email
        case emailVerified = "email_verified"
        case logo
        case name
        case notifications
        case partnered
        case twitterConnected = "twitter_conndected"
        case type
        case updatedAt = "updated_at"
    }
    
    init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.bio? = try container.decode(String.self, forKey: .bio)
        self.createdAt? = try container.decode(String.self, forKey: .createdAt)
        self.displayName = try container.decode(String.self, forKey: .displayName)
        self.email? = try container.decode(String.self, forKey: .email)
        self.emailVerified? = try container.decode(Bool.self, forKey: .emailVerified)
        self.logo? = try container.decode(String.self, forKey: .logo)
        self.name = try container.decode(String.self, forKey: .name)
        self.notifications? = try container.decode(Notifications.self, forKey: .notifications)
        self.partnered? = try container.decode(Bool.self, forKey: .partnered)
        self.twitterConnected? = try container.decode(Bool.self, forKey: .twitterConnected)
        self.type? = try container.decode(String.self, forKey: .type)
        self.updatedAt? = try container.decode(String.self, forKey: .updatedAt)
    }
}


struct Notifications: Decodable {
    var email: Bool
    var push: Bool
    
    enum CodingKeys: String, CodingKey {
        case email
        case push
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.email = try container.decode(Bool.self, forKey: .email)
        self.push = try container.decode(Bool.self, forKey: .push)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(email, forKey: .email)
        try container.encode(push, forKey: .push)
    }
}
