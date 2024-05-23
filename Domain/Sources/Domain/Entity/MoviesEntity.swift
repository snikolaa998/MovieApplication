//
//  MoviesEntity.swift
//
//
//  Created by Nikola Savic on 21.5.24..
//

import Foundation

public struct MoviesEntity: Equatable {
    public let page: Int
    public let results: [MovieEntity]?
    public let total_pages: Int?
    public let total_results: Int?
    
    public init(
        page: Int,
        results: [MovieEntity]?,
        total_pages: Int?,
        total_results: Int?
    ) {
        self.page = page
        self.results = results
        self.total_pages = total_pages
        self.total_results = total_results
    }
}
