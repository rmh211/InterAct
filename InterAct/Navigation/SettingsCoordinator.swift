//
//  SettingsCoordinator.swift
//  InterAct
//
//  Created by Robert Huber on 10/3/22.
//

import Foundation
import UIKit

protocol SettingsCoordinatorDelegate: AnyObject {
    func settingsCoordinatorDidSaveSettings(_ settingsCoordinator: SettingsCoordinator)
}

class SettingsCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var delegate: SettingsCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.navigationBar.prefersLargeTitles = true
    }
    
    func start() {
        showSettings()
    }
    func showSettings() {
        settingsViewController()
    }
    func showFrequency() {
        frequencyViewController()
    }
}
extension SettingsCoordinator: SettingsViewModelCoordinatorDelegate {
    func settingsViewControllerDidSelectFrequency(_ settingsViewModel: SettingsViewModel) {
        showFrequency()
    }
    
    func settingsViewControllerDidSaveSettings(_ settingViewModel: SettingsViewModel) {
        delegate?.settingsCoordinatorDidSaveSettings(self)
    }
    
    func settingsViewController() {
        if let viewController = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SettingsView") as? SettingsViewController {
            viewController.viewModel = SettingsViewModel()
            viewController.viewModel?.coordinatorDelegate = self
            navigationController.pushViewController(viewController, animated: true)
        }
    }
}
extension SettingsCoordinator: FrequencyViewModelCoordinatorDelegate {
    func frequencyViewControllerDidSelectFrequencsy(_ frequencyViewModel: FrequencyViewModel) {
       let _ = navigationController.viewControllers.popLast()
    }
    
    func frequencyViewController() {
        if let viewController = UIStoryboard(name: "FrequencySetting", bundle: nil).instantiateViewController(withIdentifier: "FrequencySetting") as? FrequencySettingViewController {
            viewController.viewModel = FrequencyViewModel()
            viewController.viewModel?.coordinatorDelegate = self
            navigationController.pushViewController(viewController, animated: true)
        }
    }
}
