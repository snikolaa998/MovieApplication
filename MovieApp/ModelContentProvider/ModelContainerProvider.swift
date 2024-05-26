//
//  ModelContainerProvider.swift
//  MovieApp
//
//  Created by Nikola Savic on 25.5.24..
//

import Foundation
import Domain
import SwiftData

final class ModelContainerProvider {
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: Schema([MovieOffline.self, CompaniesOffline.self, GenreOffline.self, FavoriteMovieOffline.self, DetailsMovieOffline.self]))
        } catch {
            fatalError("Init error")
        }
    }
}
