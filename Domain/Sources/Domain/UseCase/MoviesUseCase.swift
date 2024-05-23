//
//  MoviesUseCase.swift
//
//
//  Created by Nikola Savic on 21.5.24..
//

import Foundation

public protocol MoviesUseCaseProtocol {
    func getMovies(page: Int, searchCriteria: String) async throws -> MoviesEntity
}

public struct MoviesUseCase<T: MoviesRepositoryProtocol>: MoviesUseCaseProtocol {
    private let repo: T
    
    public init(
        repo: T
    ) {
        self.repo = repo
    }
    
    public func getMovies(page: Int, searchCriteria: String) async throws -> MoviesEntity {
        if searchCriteria.isEmpty {
            return try await repo.getMovies(page: page)
        } else {
            return try await repo.getSearchedMovies(page: page, searchCriteria: searchCriteria)
        }
    }
}