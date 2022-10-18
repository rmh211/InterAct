//
//  NotesViewController.swift
//  InterAct
//
//  Created by Robert Huber on 10/6/22.
//

import UIKit

class NotesViewController: PopOverViewController {
    var notesTextView: UITextView!
    var viewModel: NotesViewModel? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        makeBackgroundBlurred()
        createFloatingView(withBackgroundColor: UIColor(named: "primaryBlue") ?? .systemGray5, andBorderColor: UIColor(named: "accentBlue") ?? .clear, height: UIScreen.main.bounds.height / 2, width: 350, alignment: .top, withYPadding: 50)
        addTextView()
        addSaveButton()
        addCancelButton()
        viewModel?.addTitle()
        mainView.clipsToBounds = true
    }
    override func viewDidAppear(_ animated: Bool) {
        viewModel?.presentSavedNotes()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
   }
   //Calls this function when the tap is recognized.
   @objc func dismissKeyboard() {
       view.endEditing(true)
   }
    func add(title: String) {
        let titleLabelFrame = CGRect(x: 0, y: 0, width: mainView.bounds.width, height: 50)
        let titleLabel = UILabel(frame: titleLabelFrame)
        titleLabel.textAlignment = .center
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 28, weight: .semibold)
        titleLabel.textColor = UIColor(named: "accentBlue")
        mainView.addSubview(titleLabel)
    }
    func addTextView() {
        let textViewFrame = CGRect(x: 20, y: 55, width: mainView.bounds.width - 40, height: mainView.bounds.height - 120)
        notesTextView = UITextView(frame: textViewFrame)
        notesTextView.layer.cornerRadius = 20
        notesTextView.font = .systemFont(ofSize: 20)
        notesTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        mainView.addSubview(notesTextView)
    }
    func addSaveButton() {
        let buttonFrame = CGRect(x: 0, y: mainView.bounds.height - 50, width: mainView.bounds.width/2 - 1, height: 50)
        let saveButton = UIButton(frame: buttonFrame)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(UIColor(named: "tan"), for: .normal)
        saveButton.backgroundColor = UIColor(named: "accentBlue")
        mainView.addSubview(saveButton)
    }
    func addCancelButton() {
        let buttonFrame = CGRect(x: mainView.bounds.width/2 + 1, y: mainView.bounds.height - 50, width: mainView.bounds.width/2, height: 50)
        let cancelButton = UIButton(frame: buttonFrame)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.backgroundColor = UIColor(named: "accentBlue")
        cancelButton.setTitleColor(UIColor(named: "tan"), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelNote), for: .touchUpInside)
        mainView.addSubview(cancelButton)
    }
    @objc func saveButtonTapped(_ sender: Any) {
        guard let notes = notesTextView.text else { return }
        viewModel?.saveNotes(notes: notes)
    }
    @objc func cancelNote() {
        self.dismiss(animated: true)
    }
}
extension NotesViewController: NotesViewModelDelegate {
    func notesViewModel(_ notesViewModel: NotesViewModel, willAddTitle title: String) {
        add(title: title)
    }
    func notesViewModel(_ notesViewModel: NotesViewModel, willPresentSavedNotes notes: String) {
        notesTextView.text = notes
    }
}
