//
//  MovieEntityDTO.swift
//
//
//  Created by Nikola Savic on 21.5.24..
//

import Foundation

public struct MovieEntityDTO: Decodable {
    public let id: Int
    public let posterPath: String?
    public let title: String?
    public let voteAverage: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case title
        case voteAverage = "vote_average"
    }
}
