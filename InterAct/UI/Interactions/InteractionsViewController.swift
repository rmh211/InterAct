//
//  InteractionsViewController.swift
//  InterAct
//
//  Created by Robert Huber on 10/2/22.
//

import UIKit

class InteractionsViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
            profileImageView.makeRound()
            profileImageView.contentMode = .scaleToFill
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
    var viewModel: InteractionsViewModel? {
        didSet {
            viewModel?.viewDelegate = self
            title = viewModel?.title
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addInteractionButton = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(addInteraction))
        navigationItem.rightBarButtonItems = [addInteractionButton]
        interactionsTableView.dataSource = viewModel
        interactionsTableView.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        viewModel?.loadInteractions()
        viewModel?.updatePerson()
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
    
}
