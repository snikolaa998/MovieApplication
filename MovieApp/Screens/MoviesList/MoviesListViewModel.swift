//
//  MoviesListViewModel.swift
//  MovieApp
//
//  Created by Nikola Savic on 21.5.24..
//

import SwiftUI
import Combine
import SwiftData
import Networking
import Domain

final class MoviesListViewModel: ViewModel {
    struct State: Equatable {
        var movies: [MovieEntity] = []
        var lastTextValue = ""
        var isLoading = false
        var toast: Toast?
    }
    
    enum Action {
        case onAppear
        case clearSearchTerm
        case getMovies(String)
        case search(String)
        case clearArray
        case onItemTapped(Int)
        case loadLocalMovies
        case onFavoritesTapped
    }
    
    @Published var state = State()
    @Published var searchTerm = ""
    
    private let onItemTapped: (Int) -> Void
    private let onFavoritesTapped: () -> Void
    private let moviesUseCase: MoviesUseCaseProtocol
    private let loadMorePagesOffset = 3
    private let debounce: Int
    
    private var currentPage = 1
    private var cancellables = Set<AnyCancellable>()
    
    private var container: ModelContainer?
    
    init(debounce: Int = 1,
         moviesUseCase: MoviesUseCaseProtocol,
         container: ModelContainer?,
         onItemTapped: @escaping(Int) -> Void,
         onFavoritesTapped: @escaping () -> Void
    ) {
        self.debounce = debounce
        self.moviesUseCase = moviesUseCase
        self.onItemTapped = onItemTapped
        self.onFavoritesTapped = onFavoritesTapped
        self.container = container
        bindSearchTextListener()
    }
    
    func dispatch(_ action: Action) {
        switch action {
        case .clearSearchTerm:
            searchTerm = ""
            state.lastTextValue = ""
            dispatch(.clearArray)
            dispatch(.getMovies(""))
        case .onAppear:
            dispatch(.getMovies(""))
        case .getMovies(let searchTerm):
            Task { [weak self] in
                guard let self else { return }
                if Reachability().isConnectedToNetwork() {
                    await fetchMovies(for: searchTerm)
                } else {
                    dispatch(.loadLocalMovies)
                }
            }
        case .search(let searchTerm):
            if state.lastTextValue != searchTerm {
                state.lastTextValue = searchTerm
                dispatch(.clearArray)
                dispatch(.getMovies(searchTerm))
            }
        case .clearArray:
            currentPage = 1
            state.movies = []
        case .onItemTapped(let movieId):
            onItemTapped(movieId)
        case .loadLocalMovies:
            Task { @MainActor [weak self] in
                guard let self else { return }
                await self.loadMovies()
            }
        case .onFavoritesTapped:
            onFavoritesTapped()
        }
    }
    
    func fetchMoreIfNeeded(at index: Int) {
        guard index >= state.movies.count - loadMorePagesOffset, !state.isLoading else { return }

        currentPage+=1

        state.isLoading = true
        dispatch(.getMovies(state.lastTextValue))
    }
    
    private func bindSearchTextListener() {
        self.$searchTerm
            .debounce(for: .seconds(debounce), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
            .sink(receiveValue: { [weak self] in
                guard let self else { return }
                if Reachability().isConnectedToNetwork() {
                    self.dispatch(.search($0))
                } else {
                    Task { [weak self] in
                        guard let self else { return }
                        await self.searchLocalMovies(for: self.searchTerm)
                    }
                }
            })
            .store(in: &cancellables)
    }
    
    @MainActor
    private func searchLocalMovies(for searchTerm: String) async {
        if searchTerm != "" {
            let predicate = #Predicate<MovieOffline> { movie in
                movie.title?.localizedStandardContains(searchTerm) ?? false
            }
            let descriptor = FetchDescriptor(predicate: predicate)
            let movies = try? container?.mainContext.fetch(descriptor)
            state.movies = []
            updateMoviesList(movies: movies ?? [])
        } else {
            state.movies = []
            dispatch(.loadLocalMovies)
        }
    }
    
    private func updateMoviesList(movies: [MovieOffline]) {
        for movie in movies {
            state.movies.append(
                .init(
                    id: movie.id,
                    posterPath: movie.posterPath,
                    title: movie.title,
                    budget: movie.budget,
                    releaseDate: movie.releaseDate,
                    runtime: movie.runtime,
                    genres: [],
                    voteAverage: movie.voteAverage,
                    voteCount: movie.voteCount,
                    revenue: movie.revenue,
                    overview: movie.overview,
                    popularity: movie.popularity,
                    productionCompanies: [],
                    imdbId: movie.imdbId
                )
            )
        }
    }
    
    private func fetchMovies(for searchTerm: String) async {
        let movies = try? await self.moviesUseCase.getMovies(
            page: currentPage,
            searchCriteria: searchTerm
        ).results ?? []

        await fillData(with: movies ?? [])
        await saveDatatoLocalDB(for: movies ?? [])
    }
    
    @MainActor
    private func fillData(with movies: [MovieEntity]) {
        state.movies.append(contentsOf: movies)
        state.isLoading = false
    }
    
    @MainActor
    private func saveDatatoLocalDB(for movies: [MovieEntity]) async {
        for movie in movies {
            if !doesObjectExist(id: movie.id) {
                let offlineMovie = MovieOffline(
                    id: movie.id,
                    posterPath: movie.posterPath,
                    title: movie.title,
                    voteAverage: movie.voteAverage,
                    budget: movie.budget,
                    releaseDate: movie.releaseDate,
                    runtime: movie.runtime,
                    voteCount: movie.voteCount,
                    revenue: movie.revenue,
                    overview: movie.overview,
                    popularity: movie.popularity,
                    productionCompanies: [],
                    genres: [],
                    imdbId: movie.imdbId
                )
                container?.mainContext.insert(offlineMovie)
            }
        }
    }
    
    @MainActor
    private func loadMovies() async {
        let descriptor = FetchDescriptor<MovieOffline>()
        let movies = (try? container?.mainContext.fetch(descriptor)) ?? []
        updateMoviesList(movies: movies)
    }
    
    @MainActor
    private func getObject(id: Int) -> MovieOffline? {
        do {
            let predicate = #Predicate<MovieOffline> { object in
                object.id == id
            }
            var descriptor = FetchDescriptor(predicate: predicate)
            descriptor.fetchLimit = 1
            let object = try container?.mainContext.fetch(descriptor)
            return object?.first
        } catch {
            state.toast = Toast(style: .info, message: "There is an error. Please try again later.")
            return nil
        }
    }
    
    @MainActor
    private func doesObjectExist(id: Int) -> Bool {
        return getObject(id: id) != nil
    }
}
