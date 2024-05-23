//
//  MoviesRepository.swift
//
//
//  Created by Nikola Savic on 23.5.24..
//

import Foundation
import Domain
import Networking

public struct MoviesRepository: MoviesRepositoryProtocol {
    public static var newRepo: MoviesRepository {
        MoviesRepository(service: NetworkingService.shared)
    }
    
    private let service: NetworkingService
    
    init(service: NetworkingService) {
        self.service = service
    }
    
    public func getMovies(page: Int) async throws -> MoviesEntity {
        guard let request = MoviesListAPIRequest(
            authorization: .init(apiKey: APIConstants.apiKey),
            page: page
        ).generateURLRequest() else {
            throw APIError.notFound
        }
        
        let movies: MoviesEntityDTO = try await service.send(request)
        return movies.toMoviesEntity()
    }
    
    public func getSearchedMovies(page: Int, searchCriteria: String) async throws -> MoviesEntity {
        guard let request = SearchMovieAPIRequest(
            authorization: .init(apiKey: APIConstants.apiKey),
            page: page,
            searchCriteria: searchCriteria
        ).generateURLRequest() else {
            throw APIError.notFound
        }
        
        let movies: MoviesEntityDTO = try await service.send(request)
        return movies.toMoviesEntity()
    }
}
