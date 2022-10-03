//
//  TrackInteractionViewModel.swift
//  InterAct
//
//  Created by Robert Huber on 9/29/22.
//

import Foundation
import UIKit
import CoreData

protocol PersonListViewModelCoordinatorDelegate: AnyObject {
    func personListViewController()
    func personListViewController(_ personListViewModel: PersonListViewModel, willAddPersonToContext context: NSManagedObjectContext)
    func personListViewController(_ personListViewModel: PersonListViewModel, didSelectPersonToRecordTransactionWith person: Person, in context: NSManagedObjectContext)
    func personListViewControllerDidSelectOpenSettings(_ personListViewModel: PersonListViewModel)
    func personListViewController(_ personListViewModel: PersonListViewModel, didSelectPerson person: Person, in context: NSManagedObjectContext)
    
}
protocol PersonListViewModelDelegate: AnyObject {
    func personListViewModelDidUpdateTableData(_ personListViewModel: PersonListViewModel)
    
}
class PersonListViewModel: NSObject {
    weak var viewDelegate: PersonListViewModelDelegate?
    weak var coordinatorDelegate: PersonListViewModelCoordinatorDelegate?
    let title = "People"
    var people: [Person]?
    var filteredPeople: [Person] = []
    var context: NSManagedObjectContext?
    var regularity = 0
    var regularitySeconds: Double = 604800
    let defaults = UserDefaults.standard
    
    func fetchPeople() {
        do {
            people = try context?.fetch(Person.fetchRequest())
            guard let people = people else {return}
            filteredPeople = people.sorted()
            DispatchQueue.main.async {
                self.viewDelegate?.personListViewModelDidUpdateTableData(self)
            }
        } catch {
            print("Error: \(error)")
        }
        
    }
    func addPerson() {
        guard let context = self.context else { return }
        coordinatorDelegate?.personListViewController(self, willAddPersonToContext: context)
    }
    func removePerson(at row: Int) {
        let personToRemove = filteredPeople[row]
        if let interactions = personToRemove.interactions {
            for interaction in interactions {
                self.context?.delete(interaction as! Interaction)
            }
        }
        self.context?.delete(personToRemove)
        do {
            try context?.save()
        } catch {
            print("Error: \(error)")
        }
    }
    func addInteraction(with indexOfPerson: Int) {
        let person = filteredPeople[indexOfPerson]
        guard let context = context else { return }
        coordinatorDelegate?.personListViewController(self, didSelectPersonToRecordTransactionWith: person, in: context)
    }
    func didSelectPerson(at indexOfPerson: Int) {
        guard let context = context else { return }
        coordinatorDelegate?.personListViewController(self, didSelectPerson: filteredPeople[indexOfPerson], in: context)
    }
    func openSettings() {
        coordinatorDelegate?.personListViewControllerDidSelectOpenSettings(self)
    }
    func getRegularity() {
        regularity = defaults.integer(forKey: "Regularity")
        switch regularity {
        case 0:
            regularitySeconds = 604800
        case 1:
            regularitySeconds = (2 * 604800)
        case 2:
            regularitySeconds = 2592000
        case 3:
            regularitySeconds = (2 * 25920000)
        case 4:
            regularitySeconds = (6 * 25920000)
        case 5:
            regularitySeconds = (12 * 2592000)
        default:
            regularitySeconds = 604800
        }
        
    }
}
extension PersonListViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPeople.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as? PersonTableViewCell else { return UITableViewCell() }
        let person = filteredPeople[indexPath.row]
        cell.nameLabel.text = person.name
        cell.portraitImageView.image = UIImage(data: person.image)
        cell.alertIconImageView.image = UIImage(systemName: "exclamationmark.circle")
        cell.alertIconImageView.tintColor = UIColor(named: "attention")
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        var interactionQuality = ""
        if let unsortedInteractions = person.interactions?.array as? [Interaction] {
            if unsortedInteractions.count > 0 {
               var interactions = unsortedInteractions.sorted()
                if let interaction = interactions.last {
                    switch interaction.interactionQuality {
                    case 0:
                        interactionQuality = "\nin passing"
                    case 1:
                        interactionQuality = "\nscheduled meeting"
                    default:
                        print("Error")
                    }
                    cell.lastInteractionDateLabel.text = dateFormatter.string(from: interaction.date) + interactionQuality
                    let timePassed = interaction.date.timeIntervalSinceNow
                    switch timePassed {
                    case _ where abs(timePassed) < (regularitySeconds / 2):
                        cell.alertIconImageView.image = UIImage(systemName: "checkmark.circle")
                        cell.alertIconImageView.tintColor = UIColor(named: "good")
                    case _ where abs(timePassed) < regularitySeconds:
                        cell.alertIconImageView.image = UIImage(systemName: "exclamationmark.circle")
                        cell.alertIconImageView.tintColor = UIColor(named: "attention")
                    default:
                        cell.alertIconImageView.image = UIImage(systemName: "xmark.circle")
                        cell.alertIconImageView.tintColor = UIColor(named: "warning")
                    }
                }
            }
        }
        return cell
    }
}
extension PersonListViewModel: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let people = people else { return }
        filteredPeople = searchText.isEmpty ? people : people.filter { (item: Person) -> Bool in
            return item.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        viewDelegate?.personListViewModelDidUpdateTableData(self)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            searchBar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.showsCancelButton = false
            searchBar.text = ""
            searchBar.resignFirstResponder()
    }
}

