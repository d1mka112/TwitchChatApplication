//
//  UsersInfo.swift
//  TwitchChatApplication
//
//  Created by Mac on 19.05.2021.
//

import Foundation

struct UsersInfo: Decodable {
    var total: Int
    var users: [UserInfo]
    
    enum CodingKeys: String, CodingKey {
        case total = "_total"
        case users
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.total = try container.decode(Int.self, forKey: .total)
        self.users = try container.decode([UserInfo].self, forKey: .users)
    }
}
