//
//  SearchMovieAPIRequest.swift
//
//
//  Created by Nikola Savic on 23.5.24..
//

import Foundation

public struct SearchMovieAPIRequest: MovieGetAPIRequest {
    public typealias ResponseType = MoviesEntityDTO
    
    public var endpoint: String { "search/movie" }
    
    public var authorization: Authorization?
    
    private let page: Int
    private let searchCriteria: String
    
    public init(
        authorization: Authorization?,
        page: Int,
        searchCriteria: String
    ) {
        self.authorization = authorization
        self.page = page
        self.searchCriteria = searchCriteria
    }
    
    public var queryItems: [URLQueryItem] {
        [
            .init(name: "query", value: searchCriteria),
            .init(name: "language", value: "en-US"),
            .init(name: "page", value: "\(page)")
        ]
    }
}
