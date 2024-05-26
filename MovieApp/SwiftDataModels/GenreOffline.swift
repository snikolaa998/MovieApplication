//
//  GenreOffline.swift
//  MovieApp
//
//  Created by Nikola Savic on 25.5.24..
//

import Foundation
import SwiftData

@Model
class GenreOffline {
    @Attribute(.unique)
    public let id: Int?
    public let name: String?
    
    init(id: Int?, name: String?) {
        self.id = id
        self.name = name
    }
}
