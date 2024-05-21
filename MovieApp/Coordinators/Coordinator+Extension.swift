//
//  Coordinator+Extension.swift
//  MovieApp
//
//  Created by Nikola Savic on 21.5.24..
//

import UIKit

extension Coordinator {
    /// Searches parent coordinators stack to find mainCoordinator
    var mainCoordinator: MainCoordinator? {
        func searchForMainCoordinator() -> MainCoordinator? {
            if let mainCoordinator = self as? MainCoordinator {
                return mainCoordinator
            }
            guard let mainCoordinator = parentCoordinator as? MainCoordinator else {
                parentCoordinator = parentCoordinator?.parentCoordinator
                return parentCoordinator == nil ? nil : searchForMainCoordinator()
            }

            return mainCoordinator
        }

        return searchForMainCoordinator()
    }

    func coordinateToParent() {
        parentCoordinator?.childDidFinish(self)
    }

    /**
      Call while child flow is finishing, example user finishes profiling and is moved to home.
      Removes child from the stack, and passes navigation delegation to self if self conforms to `UINavigationControllerDelegate`
      - Parameter child: Coordinator to be removed
     */
    func childDidFinish(_ child: Coordinator?) {
        childCoordinators.removeAll(where: {
            $0 === child
        })
        if let navigationControllerDelegate = self as? UINavigationControllerDelegate {
            navigationController.delegate = navigationControllerDelegate
        }
    }

    /// Removes all coordinators from the stack, which might result in self becoming delegate of
    /// `UINavigationControllerDelegate` if conforms to
    func removeAllChildren() {
        childCoordinators.forEach {
            $0.removeAllChildren()
        }
        childCoordinators = []
    }

    /// Call while adding child flow, example user goes from settings to off-boarding which has it's own coordinator
    /// adds child to the stack
    /// - Parameter coordinator: child coordinator to be added
    func addChild(_ coordinator: Coordinator) {
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
    }

    func pushViewController(_ viewController: UIViewController, animated: Bool = true) {
        navigationController.pushViewController(viewController, animated: animated)
    }

    func popViewController(animated: Bool = true) {
        navigationController.popViewController(animated: animated)
    }

    func present(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        navigationController.present(viewController, animated: animated, completion: completion)
    }
}
