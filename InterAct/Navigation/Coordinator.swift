//
//  Coordinator.swift
//  InterAct
//
//  Created by Robert Huber on 9/29/22.
//

import Foundation
import UIKit
import CoreData

protocol Coordinator {
    var navigationController: UINavigationController {get set}
    
    func start()
}

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.navigationBar.prefersLargeTitles = true
    }
    func start() {
        showPersonList()
    }
    func addPerson(withContext managedObjectContext: NSManagedObjectContext) {
        addPersonViewController(managedObjectContext)
    }
    func showPersonList() {
        personListViewController()
    }
    func addInteraction(with person: Person, in context: NSManagedObjectContext){
        recordInteractionViewController(willRecordTransactionWith: person, inContext: context)
    }
    func openSettings() {
        settingsViewController()
    }
    func showDetailInteractionsView(of person: Person, in context: NSManagedObjectContext) {
        interactionsViewController(didSelectPerson: person, in: context)
    }
}
extension AppCoordinator: PersonListViewModelCoordinatorDelegate {
    func personListViewController(_ personListViewModel: PersonListViewModel, didSelectPerson person: Person, in context: NSManagedObjectContext) {
        showDetailInteractionsView(of: person, in: context)
    }
    
    func personListViewControllerDidSelectOpenSettings(_ personListViewModel: PersonListViewModel) {
        openSettings()
    }
    
    func personListViewController(_ personListViewModel: PersonListViewModel, didSelectPersonToRecordTransactionWith person: Person, in context: NSManagedObjectContext) {
        addInteraction(with: person, in: context)
    }
    
    func personListViewController() {
        if let viewController = UIStoryboard(name: "PersonList", bundle: nil).instantiateViewController(withIdentifier: "PersonList") as? PersonListViewController {
            viewController.viewModel = PersonListViewModel()
            viewController.viewModel?.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            viewController.viewModel?.coordinatorDelegate = self
            navigationController.viewControllers = []
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    func personListViewController(_ personListViewModel: PersonListViewModel, willAddPersonToContext context: NSManagedObjectContext) {
        addPerson(withContext: context)
    }
}
extension AppCoordinator: AddPersonViewModelCoordinatorDelegate {
    func addPersonViewController(_ managedObjectContext: NSManagedObjectContext) {
        if let viewController = UIStoryboard(name: "AddPerson", bundle: nil).instantiateViewController(withIdentifier: "AddPerson") as? AddPersonViewController {
            viewController.viewModel = AddPersonViewModel()
            viewController.viewModel?.coordinatorDelegate = self
            viewController.viewModel?.context = managedObjectContext
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    func addPersonViewControllerDidAddPerson(_ addPersonViewModel: AddPersonViewModel) {
        showPersonList()
    }
}
extension AppCoordinator: RecordInteractionViewModelCoordinatorDelegate {
    func recordInteractionViewControllerDidRecordTransaction(_ recordInteractionViewModel: RecordInteractionViewModel) {
        navigationController.viewControllers.popLast()
    }
    
    func recordInteractionViewController(willRecordTransactionWith person: Person, inContext context: NSManagedObjectContext) {
        if let viewController = UIStoryboard(name: "RecordInteraction", bundle: nil).instantiateViewController(withIdentifier: "RecordInteraction") as? RecordInteractionViewController {
            viewController.viewModel = RecordInteractionViewModel()
            viewController.viewModel?.coordinatorDelegate = self
            viewController.viewModel?.person = person
            viewController.viewModel?.context = context
            navigationController.pushViewController(viewController, animated: true)
        }
    }
}
extension AppCoordinator: SettingsViewModelCoordinatorDelegate {
    func settingsViewControllerDidSaveSettings(_ settingViewModel: SettingsViewModel) {
        showPersonList()
    }
    
    func settingsViewController() {
        if let viewController = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SettingsView") as? SettingsViewController {
            viewController.viewModel = SettingsViewModel()
            viewController.viewModel?.coordinatorDelegate = self
            navigationController.pushViewController(viewController, animated: true)
        }
    }
}
extension AppCoordinator: InteractionsViewModelCoordinatorDelegate {
    func interactionsViewController(_ interactionsViewModel: InteractionsViewModel, didSelectAddInteractionWithPerson person: Person, in context: NSManagedObjectContext) {
        addInteraction(with: person, in: context)
    }
    
    func interactionsViewController(didSelectPerson person: Person, in context: NSManagedObjectContext) {
        if let viewController = UIStoryboard(name: "Interactions", bundle: nil).instantiateViewController(withIdentifier: "Interactions") as? InteractionsViewController {
            viewController.viewModel = InteractionsViewModel()
            viewController.viewModel?.person = person
            viewController.viewModel?.coordinatorDelegate = self
            viewController.viewModel?.context = context
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    
}
