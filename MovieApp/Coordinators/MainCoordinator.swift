//
//  MainCoordinator.swift
//  MovieApp
//
//  Created by Nikola Savic on 21.5.24..
//

import UIKit

final class MainCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var dependencies: Dependencies
    var modelContainerProvider: ModelContainerProvider
    
    func begin() {
        showMoviesListScreen()
    }
    
    public init(
        navigationController: UINavigationController,
        dependencies: Dependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.modelContainerProvider = ModelContainerProvider()
    }
    
    private func showMoviesListScreen() {
        let vc = MoviesListScreen(
            viewModel: .init(
                moviesUseCase: self.dependencies.moviesUseCase, 
                container: self.modelContainerProvider.container,
                onItemTapped: { movieID in
                    self.showMovieDetailsScreen(id: movieID)
                },
                onFavoritesTapped: {
                    self.showFavoritesMovies()
                }
            )
        ).hosted
        
        pushViewController(vc)
    }
    
    private func showMovieDetailsScreen(id: Int) {
        let vc = MovieDetailsScreen(
            viewModel: .init(
                moviesUseCase: self.dependencies.moviesUseCase,
                id: id, 
                container: self.modelContainerProvider.container,
                onDismiss: { self.popViewController(animated: true) }
            )
        ).hosted
        
        pushViewController(vc)
    }
    
    private func showFavoritesMovies() {
        let vc = FavoriteMoviesScreen(
            viewModel: .init(
                container: self.modelContainerProvider.container,
                onDismiss: { self.popViewController() }, 
                onItemTapped: { movieID in
                    self.showMovieDetailsScreen(id: movieID)
                }
            )
        ).hosted
        
        pushViewController(vc)
    }
}

