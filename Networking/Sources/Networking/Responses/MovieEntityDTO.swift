//
//  MovieEntityDTO.swift
//
//
//  Created by Nikola Savic on 21.5.24..
//

import Foundation

//public struct MovieEntityDTO: Decodable {
//    public let id: Int
//    public let posterPath: String?
//    public let title: String?
//    public let voteAverage: Double?
//    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case posterPath = "poster_path"
//        case title
//        case voteAverage = "vote_average"
//    }
//}

public struct MovieEntityDTO: Decodable {
    public let id: Int
    public let posterPath: String?
    public let title: String?
    public let budget: Int?
    public let backdropPath: String?
    public let overview: String?
    public let releaseDate: String?
    public let runtime: Int?
    public let genres: [GenreEntityDTO]?
    public let voteAverage: Double?
    public let voteCount: Int?
    public let revenue: Int?
    public let popularity: Double
    public let productionCompanies: [CompaniesEntityDTO]?
    public let imdbId: String?

    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case title
        case budget
        case overview
        case releaseDate = "release_date"
        case runtime
        case genres
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case revenue
        case popularity
        case productionCompanies = "production_companies"
        case imdbId = "imdb_id"
    }
}
