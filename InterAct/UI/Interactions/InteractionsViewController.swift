//
//  InteractionsViewController.swift
//  InterAct
//
//  Created by Robert Huber on 10/2/22.
//

import UIKit

class InteractionsViewController: UIViewController, Noteable {
    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
            profileImageView.makeRound()
            profileImageView.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.font = .systemFont(ofSize: 25, weight: .medium)
        }
    }
    var addInteractionButton: UIBarButtonItem!
    var interactions: [Interaction] = []
    @IBOutlet weak var interactionsTableView: UITableView!
    var notes: String? {
        didSet {
            viewModel?.notes = notes
        }
    }
    var viewModel: InteractionsViewModel? {
        didSet {
            viewModel?.viewDelegate = self
            title = viewModel?.title
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addInteractionButton = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(addInteraction))
        viewModel?.loadPerson()
        navigationItem.rightBarButtonItems = [addInteractionButton]
        interactionsTableView.dataSource = viewModel
        interactionsTableView.delegate = self
        viewModel?.loadInteractions()
        interactionsTableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        viewModel?.loadInteractions()
        viewModel?.savePerson()
        viewModel?.loadPerson()
        interactionsTableView.reloadData()
    }
    @IBAction func notesButtonTapped(_ sender: Any) {
        viewModel?.didSelectNotes()
    }
    @objc func addInteraction() {
        viewModel?.addInteraction()
    }
}
extension InteractionsViewController: InteractionsViewModelDelegate {
    
    func interactionsViewModel(_ interactionsViewModel: InteractionsViewModel, willUpdatePerson person: Person) {
        profileImageView.image = UIImage(data: person.image)
        nameLabel.text = person.name
    }
    
    func interactionsViewModel(_ interactionsViewModel: InteractionsViewModel, didUpdateData interactions: [Interaction]) {
        self.interactions = interactions
        interactionsTableView.reloadData()
    }
}
extension InteractionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.willDisplay(interaction: interactions[indexPath.row])
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
            self.viewModel?.removeInteraction(at: indexPath.row)
            self.viewModel?.loadInteractions()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}
