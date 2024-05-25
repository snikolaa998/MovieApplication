//
//  MovieDetailsAPIRequest.swift
//
//
//  Created by Nikola Savic on 23.5.24..
//

import Foundation

public struct MovieDetailsAPIRequest: MovieGetAPIRequest {
    public typealias ResponseType = MovieEntityDTO
    
    public var endpoint: String { "movie/\(movieId)" }
    public var authorization: Authorization?
    
    private let movieId: Int
    
    public var queryItems: [URLQueryItem] {
        [
            .init(name: "language", value: "en-US")
        ]
    }
    
    public init(
        authorization: Authorization?,
        movieId: Int
    ) {
        self.authorization = authorization
        self.movieId = movieId
    }
}
