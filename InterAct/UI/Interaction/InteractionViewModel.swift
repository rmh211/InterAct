//
//  InteractionViewModel.swift
//  InterAct
//
//  Created by Robert Huber on 10/11/22.
//

import Foundation
import CoreData
protocol InteractionViewModelCoordinatorDelegate: AnyObject {
    func interactionViewController(willDisplayInteraction interaction: Interaction, saveInConext context: NSManagedObjectContext)
    func interactionViewController(_ interactionViewModel: InteractionViewModel, didSaveInteraction interaction: Interaction)
}
protocol InteractionViewModelDelegate: AnyObject {
    func interactionViewModel(_ interactionViewModel: InteractionViewModel, willDisplayInteraction interaction: Interaction)
}
class InteractionViewModel {
    weak var coordinatorDelegate: InteractionViewModelCoordinatorDelegate?
    weak var viewDelegate: InteractionViewModelDelegate?
    var notes: String?
    var context: NSManagedObjectContext?
    var interaction: Interaction?
    
    func loadInteraction() {
        guard let interaction = interaction else { return }
        viewDelegate?.interactionViewModel(self, willDisplayInteraction: interaction)

    }
    func saveInteraction(withNotes notes: String) {
        interaction?.notes = notes
        do {
            try context?.save()
        } catch {
            print("Error: \(error)")
        }
        DispatchQueue.main.async {
            guard let interaction = self.interaction else { return }
            self.coordinatorDelegate?.interactionViewController(self, didSaveInteraction: interaction)
        }
    }
}
