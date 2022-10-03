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

    func initializeProfile() {
        guard let person = person else { return }
        viewDelegate?.recordInteractionViewModel(self, willInitializeProfile: person)

    }
    func saveInteraction(on date: Date, qualityOf quality: Int, image: UIImage) {
        if validate(date: date) {
            print("Post Validated date: \(date)")
            guard let context = context else { return }
            guard let person = person else { return }
            guard let imageData = image.pngData() else { return }
            person.image = imageData
            let interaction = Interaction(context: context)
            interaction.person = person
            interaction.date = date
            interaction.interactionQuality = quality
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
        print("Validated: \(date)")
        return date <= Date()
    }
}
