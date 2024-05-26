//
//  DetailsMovieOffline.swift
//  MovieApp
//
//  Created by Nikola Savic on 25.5.24..
//

import Foundation
import SwiftData

@Model
class DetailsMovieOffline {
    @Attribute(.unique)
    public var id: Int
    public var posterPath: String?
    public var title: String?
    public var voteAverage: Double?
    public var budget: Int?
    public var releaseDate: String?
    public var runtime: Int?
    public var voteCount: Int?
    public var revenue: Int?
    public var overview: String?
    public var popularity: Double
    public var productionCompanies: [CompaniesOffline]? = []
    public var genres: [GenreOffline]? = []
    public var imdbId: String?
    
    init(
        id: Int,
        posterPath: String?,
        title: String?,
        voteAverage: Double?,
        budget: Int?,
        releaseDate: String?,
        runtime: Int?,
        voteCount: Int?,
        revenue: Int?,
        overview: String?,
        popularity: Double,
        productionCompanies: [CompaniesOffline]?,
        genres: [GenreOffline]?,
        imdbId: String?
    ) {
        self.id = id
        self.posterPath = posterPath
        self.title = title
        self.voteAverage = voteAverage
        self.budget = budget
        self.releaseDate = releaseDate
        self.runtime = runtime
        self.voteCount = voteCount
        self.revenue = revenue
        self.overview = overview
        self.popularity = popularity
        self.productionCompanies = productionCompanies
        self.genres = genres
        self.imdbId = imdbId
    }
}
