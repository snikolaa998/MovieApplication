//
//  MovieDetailsViewModel.swift
//  MovieApp
//
//  Created by Nikola Savic on 23.5.24..
//

import Foundation
import SwiftData
import Networking
import Domain

final class MovieDetailsViewModel: ViewModel {
    struct State: Equatable {
        var movie: MovieEntity?
        var isLoading = false
        var isConnected: InternetConnectionStatus = .checking
        var isFavorite = false
        var localDetails: DetailsMovieOffline?
    }
    
    enum Action {
        case dismiss
        case getDetails
        case saveFavoriteMovie(MovieEntity?)
        case isFavorite
    }
    
    private let onDismiss: () -> Void
    private let moviesUseCase: MoviesUseCaseProtocol
    private let id: Int
    
    private var container: ModelContainer?
    
    @Published var state = State()
    
    init(
        moviesUseCase: MoviesUseCaseProtocol,
        id: Int,
        container: ModelContainer?,
        onDismiss: @escaping () -> Void
    ) {
        self.moviesUseCase = moviesUseCase
        self.id = id
        self.onDismiss = onDismiss
        self.container = container
        if Reachability().isConnectedToNetwork() {
            self.state.isConnected = .hasConnection
        } else {
            self.state.isConnected = .noConnection
            Task { @MainActor [weak self] in
                guard let self else { return }
                self.loadLocalDetails()
            }
        }
    }
    
    func dispatch(_ action: Action) {
        switch action {
        case .dismiss:
            onDismiss()
        case .isFavorite:
            Task { @MainActor [weak self] in
                guard let self else { return }
                self.state.isFavorite = doesObjectExist(id: state.movie?.id ?? 0)
            }
        case .getDetails:
            state.isLoading = true
            Task { @MainActor [weak self] in
                guard let self else { return }
                do {
                    state.movie = try await self.moviesUseCase.getMovie(id: id)
                    await saveDetailsToLocalDB()
                    state.isLoading = false
                    dispatch(.isFavorite)
                } catch {
                    state.isLoading = false
                }
            }
        case .saveFavoriteMovie(let movie):
            Task { @MainActor [weak self] in
                guard let self else { return }
                if doesObjectExist(id: movie?.id ?? 0) {
                    state.isFavorite = false
                    let object = getObject(id: movie?.id ?? 0)
                    guard object != nil else { return }
                    container?.mainContext.delete(object!)
                    do {
                        try container?.mainContext.save()
                    } catch {
                        print("Handle error with toast example...")
                    }
                } else {
                    state.isFavorite = true
                    let favoriteMovie = FavoriteMovieOffline(
                        id: movie?.id ?? 0,
                        posterPath: movie?.posterPath,
                        title: movie?.title,
                        voteAverage: movie?.voteAverage,
                        budget: movie?.budget,
                        releaseDate: movie?.releaseDate,
                        runtime: movie?.runtime,
                        voteCount: movie?.voteCount,
                        revenue: movie?.revenue,
                        overview: movie?.overview,
                        popularity: movie?.popularity ?? 0.0,
                        productionCompanies: [],
                        genres: [],
                        imdbId: movie?.imdbId
                    )
                    container?.mainContext.insert(favoriteMovie)
                }
            }
        }
    }
    
    @MainActor
    private func saveDetailsToLocalDB() async {
        if !doesObjectExist(id: state.movie?.id ?? 0) {
            let offlineDetails = DetailsMovieOffline(
                id: state.movie?.id ?? 0,
                posterPath: state.movie?.posterPath,
                title: state.movie?.title,
                voteAverage: state.movie?.voteAverage,
                budget: state.movie?.budget,
                releaseDate: state.movie?.releaseDate,
                runtime: state.movie?.runtime,
                voteCount: state.movie?.voteCount,
                revenue: state.movie?.revenue,
                overview: state.movie?.overview,
                popularity: state.movie?.popularity ?? 0.0,
                productionCompanies: (state.movie?.productionCompanies ?? []).map { .init(id: $0.id, logoPath: $0.logoPath)},
                genres: (state.movie?.genres ?? []).map { .init(id: $0.id, name: $0.name) },
                imdbId: state.movie?.imdbId
            )
            container?.mainContext.insert(offlineDetails)
        }
    }
    
    @MainActor
    private func getObject(id: Int) -> FavoriteMovieOffline? {
        do {
            let predicate = #Predicate<FavoriteMovieOffline> { object in
                object.id == id
            }
            var descriptor = FetchDescriptor(predicate: predicate)
            descriptor.fetchLimit = 1
            let object = try container?.mainContext.fetch(descriptor)
            return object?.first
        } catch {
            return nil
        }
    }
    
    @MainActor
    private func doesObjectExist(id: Int) -> Bool {
        return getObject(id: id) != nil
    }
    
    @MainActor
    private func loadLocalDetails() {
        var descriptor = FetchDescriptor<DetailsMovieOffline>()
        descriptor.fetchLimit = 1
        let details = try? container?.mainContext.fetch(descriptor)
        state.localDetails = details?.first
    }
}
