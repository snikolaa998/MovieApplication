//
//  GenresEntity.swift
//
//
//  Created by Nikola Savic on 23.5.24..
//

import Foundation

public struct GenresEntity: Equatable {
    public let genres: [GenreEntity]?
    
    init(genres: [GenreEntity]?) {
        self.genres = genres
    }
}
