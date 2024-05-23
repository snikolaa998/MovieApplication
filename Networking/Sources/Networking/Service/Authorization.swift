//
//  Authorization.swift
//  
//
//  Created by Nikola Savic on 21.5.24..
//

import Foundation

public struct Authorization: Codable {
    public var apiKey: String

    public init(apiKey: String) {
        self.apiKey = apiKey
    }
}
