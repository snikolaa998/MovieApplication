//
//  Coordinator.swift
//  MovieApp
//
//  Created by Nikola Savic on 21.5.24..
//

import UIKit

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func begin()
    func addChild(_ coordinator: Coordinator)
    func childDidFinish(_ child: Coordinator?)
    func removeAllChildren()
    
    func popViewController(animated: Bool)
    func pushViewController(_ viewController: UIViewController, animated: Bool)
}
