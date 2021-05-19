//
//  URLExtension.swift
//  TwitchChatApplication
//
//  Created by Mac on 19.05.2021.
//

import Foundation

extension URL {
    subscript(queryParam:String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        if let parameters = url.queryItems {
            return parameters.first(where: { $0.name == queryParam })?.value
        } else if let paramsPairs = url.fragment?.components(separatedBy: "?").last?.components(separatedBy: "&") {
            for pair in paramsPairs where pair.contains(queryParam) {
                return pair.components(separatedBy: "=").last
            }
            return nil
        } else {
            return nil
        }
    }
}
