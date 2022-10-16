//
//  NotesViewModel.swift
//  InterAct
//
//  Created by Robert Huber on 10/6/22.
//

import Foundation
protocol NotesViewModelCoordinatorDelegate: AnyObject {
    func notesViewController(titled title: String, withSavedNotes notes: String)
    func notesViewController(_ notesViewModel: NotesViewModel, didSaveNote notes: String)
}
protocol NotesViewModelDelegate: AnyObject {
    func notesViewModel(_ notesViewModel: NotesViewModel, willAddTitle title: String)
    func notesViewModel(_ notesViewModel: NotesViewModel, willPresentSavedNotes notes: String)
    
}
class NotesViewModel {
    weak var coordinatorDelegate: NotesViewModelCoordinatorDelegate?
    weak var viewDelegate: NotesViewModelDelegate?
    var title: String?
    var savedNotes: String?
    func addTitle() {
        guard let title = title else { return }
        viewDelegate?.notesViewModel(self, willAddTitle: title)
    }
    func saveNotes(notes: String) {
        coordinatorDelegate?.notesViewController(self, didSaveNote: notes)
    }
    func presentSavedNotes() {
        guard let savedNotes = savedNotes else { return }
        viewDelegate?.notesViewModel(self, willPresentSavedNotes: savedNotes)
    }
}

