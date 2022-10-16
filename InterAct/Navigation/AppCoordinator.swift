//
//  Coordinator.swift
//  InterAct
//
//  Created by Robert Huber on 9/29/22.
//

import Foundation
import UIKit
import CoreData
protocol AppCoordinatorDelegate: AnyObject {
    func appCoordinatorDidSelectSettings(_ appCoordinator: AppCoordinator)
}
class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var delegate: AppCoordinatorDelegate?
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
        delegate?.appCoordinatorDidSelectSettings(self)
    }
    func showDetailInteractionsView(of person: Person, in context: NSManagedObjectContext) {
        interactionsViewController(didSelectPerson: person, in: context)
    }
    func showNotesPopover(titled title: String, withNotes notes: String = "") {
        notesViewController(titled: title, withSavedNotes: notes)
    }
    func didAddNotes(notes: String) {
        navigationController.dismiss(animated: true)
        guard var vc = navigationController.viewControllers.last as? Noteable else { return }
        vc.notes = notes
    }
    func show(interaction: Interaction, in context:NSManagedObjectContext){
        interactionViewController(willDisplayInteraction: interaction, saveInConext: context)
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
    func addPersonViewController(_ addPersonViewModel: AddPersonViewModel, didRequestNotesTitled title: String) {
        showNotesPopover(titled: title)
    }
    
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
    func recordInteractionViewController(_ recordInteractionViewModel: RecordInteractionViewModel, didSelectAddNoteWithTitle title: String, withSavedNotes notes: String) {
        showNotesPopover(titled: title, withNotes: notes)
    }
    func recordInteractionViewControllerDidRecordTransaction(_ recordInteractionViewModel: RecordInteractionViewModel) {
        let _ = navigationController.viewControllers.popLast()
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
extension AppCoordinator: InteractionsViewModelCoordinatorDelegate {
    func interactionsViewController(_ interactionsViewModel: InteractionsViewModel, willDisplayInteractionDetail interaction: Interaction, saveInContext context: NSManagedObjectContext) {
        show(interaction: interaction, in: context)
    }
    
    func interactionsViewController(_ interactionsViewModel: InteractionsViewModel, didSelectAddNotes notes: String) {
        showNotesPopover(titled: "Personal Notes", withNotes: notes)
    }
    
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
extension AppCoordinator: NotesViewModelCoordinatorDelegate {
    func notesViewController(titled title: String, withSavedNotes notes: String = "") {
        if let viewController = UIStoryboard(name: "Notes", bundle: nil).instantiateViewController(withIdentifier: "Notes") as? NotesViewController {
            viewController.viewModel = NotesViewModel()
            viewController.viewModel?.title = title
            viewController.viewModel?.savedNotes = notes
            viewController.viewModel?.coordinatorDelegate = self
            viewController.modalPresentationStyle = .overCurrentContext
            navigationController.present(viewController, animated: true)
        }
    }

    func notesViewController(_ notesViewModel: NotesViewModel, didSaveNote notes: String) {
        didAddNotes(notes: notes)
    }
    
    
}
extension AppCoordinator: InteractionViewModelCoordinatorDelegate {
    func interactionViewController(_ interactionViewModel: InteractionViewModel, didSaveInteraction interaction: Interaction) {
        let _ = navigationController.viewControllers.popLast()
    }
    
    func interactionViewController(willDisplayInteraction interaction: Interaction, saveInConext context: NSManagedObjectContext)  {
        if let viewController = UIStoryboard(name: "Interaction", bundle: nil).instantiateViewController(withIdentifier: "Interaction") as? InteractionViewController {
            viewController.viewModel = InteractionViewModel()
            viewController.viewModel?.coordinatorDelegate = self
            viewController.viewModel?.interaction = interaction
            viewController.viewModel?.context = context
            navigationController.pushViewController(viewController, animated: true)
        }
    }
}
