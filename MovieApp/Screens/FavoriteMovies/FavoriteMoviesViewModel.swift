//
//  FavoriteMoviesViewModel.swift
//  MovieApp
//
//  Created by Nikola Savic on 25.5.24..
//

import Foundation
import SwiftData
import Domain

final class FavoriteMoviesViewModel: ViewModel {
    struct State: Equatable {
        var movies: [FavoriteMovieOffline] = []
    }
    
    enum Action {
        case dismiss
        case loadMovies
        case onItemTapped(Int)
    }
    
    private let onDismiss: () -> Void
    private let onItemTapped: (Int) -> Void
    private let container: ModelContainer
    
    @Published var state = State()
    
    init(
        container: ModelContainer,
        onDismiss: @escaping () -> Void,
        onItemTapped: @escaping (Int) -> Void
    ) {
        self.container = container
        self.onDismiss = onDismiss
        self.onItemTapped = onItemTapped
    }
    
    func dispatch(_ action: Action) {
        switch action {
        case .dismiss:
            onDismiss()
        case .onItemTapped(let movieID):
            onItemTapped(movieID)
        case .loadMovies:
            Task { @MainActor [weak self] in
                guard let self else { return }
                let descriptor = FetchDescriptor<FavoriteMovieOffline>()
                state.movies = (try? container.mainContext.fetch(descriptor)) ?? []
            }
        }
    }
}
