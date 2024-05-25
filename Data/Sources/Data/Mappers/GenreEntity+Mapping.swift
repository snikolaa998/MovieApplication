//
//  GenreEntity+Mapping.swift
//
//
//  Created by Nikola Savic on 23.5.24..
//

import Foundation
import Domain
import Networking

extension GenreEntityDTO {
    func toGenreEntity() -> GenreEntity{
        return .init(
            id: id,
            name: name
        )
    }
}
