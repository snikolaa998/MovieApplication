//
//  MoviesRepositoryProtocol.swift
//
//
//  Created by Nikola Savic on 21.5.24..
//

import Foundation

public protocol MoviesRepositoryProtocol: RepositoryProtocol {
    func getMovies(page: Int) async throws -> MoviesEntity
    func getSearchedMovies(page: Int, searchCriteria: String) async throws -> MoviesEntity
    func getMovie(id: Int) async throws -> MovieEntity
}
