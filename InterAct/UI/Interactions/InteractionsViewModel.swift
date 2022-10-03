//
//  InteractionsViewModel.swift
//  InterAct
//
//  Created by Robert Huber on 10/2/22.
//

import Foundation
import UIKit
import CoreData
protocol InteractionsViewModelCoordinatorDelegate: AnyObject {
    func interactionsViewController(didSelectPerson person: Person, in context: NSManagedObjectContext)
    func interactionsViewController(_ interactionsViewModel: InteractionsViewModel, didSelectAddInteractionWithPerson person: Person, in context: NSManagedObjectContext)
}
protocol InteractionsViewModelDelegate: AnyObject {
    func interactionsViewModel(_ interactionsViewModel: InteractionsViewModel, didUpdateData interactions: [Interaction])
    func interactionsViewModel(_ interactionsViewModel: InteractionsViewModel, willUpdatePerson person: Person)
}
class InteractionsViewModel: NSObject {
    weak var coordinatorDelegate: InteractionsViewModelCoordinatorDelegate?
    weak var viewDelegate: InteractionsViewModelDelegate?
    let title = "Interactions"
    var person: Person!
    var interactions: [Interaction] = []
    var context: NSManagedObjectContext?
    func loadInteractions() {
        guard let personInteractions = person.interactions?.array as? [Interaction] else { return }
        interactions = personInteractions
    }
}
extension InteractionsViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfInteractions = person.interactions?.array.count else { return 0}
        return numberOfInteractions
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let personInteractions = person.interactions?.array as? [Interaction] else { return UITableViewCell() }
        interactions = personInteractions
        interactions.sort()
        interactions.reverse()
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InteractionCell", for: indexPath) as? InteractionTableViewCell else { return UITableViewCell() }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        cell.dateLabel.text = dateFormatter.string(from: interactions[indexPath.row].date)
        switch interactions[indexPath.row].interactionQuality {
            case 0:
                cell.qualityLabel.text = " in passing"
            cell.qualityLabel.textColor = .systemTeal
            case 1:
                cell.qualityLabel.text = " scheduled meeting"
            cell.qualityLabel.textColor = .blue
            default:
                cell.qualityLabel.text = " need to meet"
        }
        return cell
    }
    func addInteraction(){
        guard let context = context else { return }
        coordinatorDelegate?.interactionsViewController(self, didSelectAddInteractionWithPerson: person, in: context)
    }
    func updatePerson() {
        viewDelegate?.interactionsViewModel(self, willUpdatePerson: person)
    }
}
