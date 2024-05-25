//
//  GenreEntity.swift
//  
//
//  Created by Nikola Savic on 23.5.24..
//

import Foundation

public struct GenreEntity: Equatable {
    public let id: Int?
    public let name: String?
    
    public init(
        id: Int?,
        name: String?
    ) {
        self.id = id
        self.name = name
    }
}
