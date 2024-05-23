//
//  MoviesListAPIRequest.swift
//
//
//  Created by Nikola Savic on 21.5.24..
//

import Foundation

public struct MoviesListAPIRequest: MovieGetAPIRequest {
    public typealias ResponseType = MoviesEntityDTO
    
    public var endpoint: String { "movie/top_rated"}
    public var authorization: Authorization?
    
    private let page: Int
    
    public var queryItems: [URLQueryItem] {
        [
            .init(name: "language", value: "en-US"),
            .init(name: "page", value: "\(page)")
        ]
    }
    
    public init(
        authorization: Authorization?,
        page: Int
    ) {
        self.authorization = authorization
        self.page = page
    }
}
