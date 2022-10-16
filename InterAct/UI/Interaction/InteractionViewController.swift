//
//  InteractionViewController.swift
//  InterAct
//
//  Created by Robert Huber on 10/11/22.
//

import UIKit

class InteractionViewController: UIViewController, Noteable {

    @IBOutlet weak var personNameLabel: UILabel! {
        didSet {
            personNameLabel.font = .systemFont(ofSize: 25, weight: .medium)
        }
    }
    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
            profileImageView.makeRound()
            profileImageView.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet weak var interactionQualityLabel: UILabel! {
        didSet {
            interactionQualityLabel.font = .systemFont(ofSize: 25, weight: .regular)
        }
    }
    @IBOutlet weak var notesTextView: UITextView! {
        didSet {
            notesTextView.layer.cornerRadius = 20
            notesTextView.layer.borderWidth = 1
            notesTextView.layer.borderColor = UIColor(named: "accentBlue")?.cgColor
            notesTextView.font = .systemFont(ofSize: 20)
            notesTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
    @IBOutlet weak var saveEditsButton: UIButton! {
        didSet {
            saveEditsButton.layer.cornerRadius = 5
            saveEditsButton.layer.backgroundColor = UIColor.systemBlue.cgColor
            saveEditsButton.tintColor = .white
        }
    }
    var viewModel: InteractionViewModel? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }
    var notes: String? {
        didSet {
            viewModel?.notes = notes
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.loadInteraction()

    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    @IBAction func saveEditsTapped(_ sender: Any) {
        viewModel?.saveInteraction(withNotes: notesTextView.text)
    }
}
extension InteractionViewController: InteractionViewModelDelegate {
    func interactionViewModel(_ interactionViewModel: InteractionViewModel, willDisplayInteraction interaction: Interaction) {
        personNameLabel.text = interaction.person.name
        profileImageView.image = UIImage(data: interaction.person.image)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        title = dateFormatter.string(from: interaction.date)
        switch interaction.interactionQuality {
        case 0:
            interactionQualityLabel.text = "in passing"
            interactionQualityLabel.textColor = .systemTeal
        case 1:
            interactionQualityLabel.text = "scheduled meeting"
            interactionQualityLabel.textColor = .blue
        default:
            interactionQualityLabel.text = "need to meet"
            interactionQualityLabel.textColor = .yellow
        }
        if let notes = interaction.notes {
            notesTextView.text = notes
        }
    }
    
    
}
