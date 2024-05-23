//
//  MoviesEntity+Mapping.swift
//
//
//  Created by Nikola Savic on 23.5.24..
//

import Foundation
import Domain
import Networking

extension MoviesEntityDTO {
    func toMoviesEntity() -> MoviesEntity {
        return .init(
            page: page,
            results: (results ?? []).map { $0.toMovieEntity() },
            total_pages: total_pages,
            total_results: total_results
        )
    }
}
