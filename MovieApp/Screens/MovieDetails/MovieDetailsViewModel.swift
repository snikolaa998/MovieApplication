//
//  MovieDetailsViewModel.swift
//  MovieApp
//
//  Created by Nikola Savic on 23.5.24..
//

import Foundation
import Networking
import Domain

final class MovieDetailsViewModel: ViewModel {
    struct State: Equatable {
        var movie: MovieEntity?
        var isLoading = false
        var isConnected: InternetConnectionStatus = .checking
    }
    
    enum Action {
        case dismiss
        case getDetails
    }
    
    private let onDismiss: () -> Void
    private let moviesUseCase: MoviesUseCaseProtocol
    private let id: Int
    
    @Published var state = State()
    
    init(
        moviesUseCase: MoviesUseCaseProtocol,
        id: Int,
        onDismiss: @escaping () -> Void
    ) {
        self.moviesUseCase = moviesUseCase
        self.id = id
        self.onDismiss = onDismiss
        if Reachability().isConnectedToNetwork() {
            self.state.isConnected = .hasConnection
        } else {
            self.state.isConnected = .noConnection
        }
    }
    
    func dispatch(_ action: Action) {
        switch action {
        case .dismiss:
            onDismiss()
        case .getDetails:
            state.isLoading = true
            Task { @MainActor [weak self] in
                guard let self else { return }
                do {
                    state.movie = try await self.moviesUseCase.getMovie(id: id)
                    state.isLoading = false
                } catch {
                    state.isLoading = false
                }
            }
        }
    }
}

enum InternetConnectionStatus {
    case checking
    case hasConnection
    case noConnection
}
