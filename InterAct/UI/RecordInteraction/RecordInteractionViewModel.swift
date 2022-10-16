//
//  RecordInteractionViewModel.swift
//  InterAct
//
//  Created by Robert Huber on 9/29/22.
//

import Foundation
import CoreData
import UIKit

protocol RecordInteractionViewModelCoordinatorDelegate: AnyObject {
    func recordInteractionViewController(willRecordTransactionWith person: Person, inContext context: NSManagedObjectContext)
    func recordInteractionViewControllerDidRecordTransaction(_ recordInteractionViewModel: RecordInteractionViewModel)
    func recordInteractionViewController(_ recordInteractionViewModel: RecordInteractionViewModel, didSelectAddNoteWithTitle title: String, withSavedNotes notes: String)
}
protocol RecordInteractionViewModelDelegate: AnyObject {
    func recordInteractionViewModel(_ recordInteractionViewModel: RecordInteractionViewModel, willInitializeProfile person: Person)
}

class RecordInteractionViewModel {
    weak var coordinatorDelegate: RecordInteractionViewModelCoordinatorDelegate?
    weak var viewDelegate: RecordInteractionViewModelDelegate?
    var title = "Add Interaction"
    var context: NSManagedObjectContext?
    var person: Person?
    var notes: String?
    func initializeProfile() {
        guard let person = person else { return }
        viewDelegate?.recordInteractionViewModel(self, willInitializeProfile: person)

    }
    func saveInteraction(on date: Date, qualityOf quality: Int, image: UIImage) {
        if validate(date: date) {
            guard let context = context else { return }
            guard let person = person else { return }
            guard let imageData = image.jpegData(compressionQuality: 0.9) else { return }
            person.image = imageData
            let interaction = Interaction(context: context)
            interaction.person = person
            interaction.date = date
            interaction.interactionQuality = quality
            if let notes = notes {
                interaction.notes = notes
            }
            person.addToInteractions(interaction)
            do {
                try context.save()
                DispatchQueue.main.async {
                    self.coordinatorDelegate?.recordInteractionViewControllerDidRecordTransaction(self)
                 }
            } catch {
                print("Error: \(error)")
            }
        }
    }
    func validate(date: Date) -> Bool {
        return date <= Date()
    }
    func addNotes() {
        if let notes = notes {
            coordinatorDelegate?.recordInteractionViewController(self, didSelectAddNoteWithTitle: "Edit Note", withSavedNotes: notes)
        } else {
            coordinatorDelegate?.recordInteractionViewController(self, didSelectAddNoteWithTitle: "Add Note", withSavedNotes: "")
        }
    }
}
