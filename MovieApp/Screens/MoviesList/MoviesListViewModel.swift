//
//  MoviesListViewModel.swift
//  MovieApp
//
//  Created by Nikola Savic on 21.5.24..
//

import Foundation
import Combine
import Domain

final class MoviesListViewModel: ViewModel {
    struct State: Equatable {
        var movies: [MovieEntity] = []
        var lastTextValue = ""
        var isLoading = false
    }
    
    enum Action {
        case onAppear
        case clearSearchTerm
        case getMovies(String)
        case search(String)
        case clearArray
        case onItemTapped(Int)
    }
    
    @Published var state = State()
    @Published var searchTerm = ""
    
    private let onItemTapped: (Int) -> Void
    private let moviesUseCase: MoviesUseCaseProtocol
    private let loadMorePagesOffset = 3
    private let debounce: Int
    
    private var currentPage = 1
    private var cancellables = Set<AnyCancellable>()
    
    init(debounce: Int = 1,
         moviesUseCase: MoviesUseCaseProtocol,
         onItemTapped: @escaping(Int) -> Void
    ) {
        self.debounce = debounce
        self.moviesUseCase = moviesUseCase
        self.onItemTapped = onItemTapped
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
                await fetchMovies(for: searchTerm)
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
                self.dispatch(.search($0))
            })
            .store(in: &cancellables)
    }
    
    private func fetchMovies(for searchTerm: String) async {
        let movies = try? await self.moviesUseCase.getMovies(
            page: currentPage,
            searchCriteria: searchTerm
        ).results ?? []

        await fillData(with: movies ?? [])
    }
    
    @MainActor
    private func fillData(with movies: [MovieEntity]) {
        state.movies.append(contentsOf: movies)
        state.isLoading = false
    }
}
