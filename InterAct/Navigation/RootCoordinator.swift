//
//  RootCoordinator.swift
//  InterAct
//
//  Created by Robert Huber on 10/3/22.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController {get set}
    var childCoordinators: [Coordinator] {get set}
    
    func start()
}
extension Coordinator {
    func startCoordinator(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}

class RootCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.navigationBar.prefersLargeTitles = true
    }
    
    func start() {
        showApp()
    }
    func showApp() {
        startCoordinator(coordinator: appCoordinator)
    }
    func showSettings() {
        startCoordinator(coordinator: settingsCoordinator)
    }
}
extension RootCoordinator: AppCoordinatorDelegate {
    var appCoordinator: AppCoordinator {
        let appCoordinator = AppCoordinator(navigationController: navigationController)
        appCoordinator.delegate = self
        return appCoordinator
    }
    func appCoordinatorDidSelectSettings(_ appCoordinator: AppCoordinator) {
        showSettings()
    }
}
extension RootCoordinator: SettingsCoordinatorDelegate {
    func settingsCoordinatorDidSaveSettings(_ settingsCoordinator: SettingsCoordinator) {
        showApp()
    }
    
    var settingsCoordinator: SettingsCoordinator {
        let settingsCoordinator = SettingsCoordinator(navigationController: navigationController)
        settingsCoordinator.delegate = self
        return settingsCoordinator
    }
}
