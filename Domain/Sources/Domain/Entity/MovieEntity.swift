//
//  MovieEntity.swift
//  
//
//  Created by Nikola Savic on 21.5.24..
//

import Foundation

public struct MovieEntity: Equatable {
    public let id: Int
    public let posterPath: String?
    public let title: String?
    public let voteAverage: Double?

    public init(
        id: Int,
        posterPath: String?,
        title: String?,
        voteAverage: Double?
    ) {
        self.id = id
        self.posterPath = posterPath
        self.title = title
        self.voteAverage = voteAverage
    }
}
