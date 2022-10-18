//
//  AddPersonViewModel.swift
//  InterAct
//
//  Created by Robert Huber on 9/29/22.
//

import Foundation
import CoreData
import UIKit

protocol AddPersonViewModelCoordinatorDelegate: AnyObject {
    func addPersonViewController(_ managedAppContext: NSManagedObjectContext)
    func addPersonViewControllerDidAddPerson(_ addPersonViewModel: AddPersonViewModel)
    func addPersonViewController(_ addPersonViewModel: AddPersonViewModel, didRequestNotesTitled title: String, withNotes notes: String?)
    
}
protocol AddPersonViewModelDelegate: AnyObject {
    
}

class AddPersonViewModel: Noteable {
    weak var coordinatorDelegate: AddPersonViewModelCoordinatorDelegate?
    weak var viewDelegate: AddPersonViewModelDelegate?
    let title = "Add Person"
    var notes: String?
    var context: NSManagedObjectContext?
    func savePerson(withName name: String?, image: UIImage) {
        if validate(name: name) {
            guard let name = name else { return }
            guard let context = context else { return }
            let person = Person(context: context)
            person.name = name
            guard let imageData = image.jpegData(compressionQuality: 0.9) else { return }
            person.image = imageData
            if let notes = notes {
                person.notes = notes
            }
            do {
                try self.context?.save()
                DispatchQueue.main.async {
                    self.coordinatorDelegate?.addPersonViewControllerDidAddPerson(self)
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
    func validate(name: String?) -> Bool {
        guard let name = name else {return false}
        if name.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return false
        }
        return true
    }
    func didRequestNotes(titled title: String) {
        coordinatorDelegate?.addPersonViewController(self, didRequestNotesTitled: title, withNotes: notes)
    }
}
