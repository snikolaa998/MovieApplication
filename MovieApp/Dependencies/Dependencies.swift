//
//  Dependencies.swift
//  MovieApp
//
//  Created by Nikola Savic on 21.5.24..
//

import Foundation
import Domain
import Data

class Dependencies {
    private static var instancesCount = 0
    init() {
        Dependencies.instancesCount += 1
    }
    
    lazy var moviesUseCase: MoviesUseCase = {
        MoviesUseCase(repo: MoviesRepository.newRepo)
    }()
}
