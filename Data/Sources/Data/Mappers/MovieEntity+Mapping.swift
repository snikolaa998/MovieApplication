//
//  MovieEntityDTO+Mapping.swift
//
//
//  Created by Nikola Savic on 21.5.24..
//

import Foundation
import Domain
import Networking

extension MovieEntityDTO {
    func toMovieEntity() -> MovieEntity {
        return .init(
            id: id,
            posterPath: posterPath,
            title: title,
            voteAverage: voteAverage
        )
    }
}
