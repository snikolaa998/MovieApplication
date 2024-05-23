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
    
    func begin() {
        showSplashScreen()
    }
    
    public init(
        navigationController: UINavigationController,
        dependencies: Dependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    private func showSplashScreen() {
        let vc = MoviesListScreen(
            viewModel: .init(
                moviesUseCase: self.dependencies.moviesUseCase
            )
        ).hosted
        
        pushViewController(vc, animated: true)
    }
}

