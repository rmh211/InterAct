//
//  PersonListViewController.swift
//  InterAct
//
//  Created by Robert Huber on 9/29/22.
//

import UIKit

class PersonListViewController: UIViewController {
    
    @IBOutlet weak var personListTableView: UITableView!
    @IBOutlet weak var personListSearchBar: UISearchBar!
    var addPersonBarButton: UIBarButtonItem!
    var settingsBarButton: UIBarButtonItem!
    var viewModel: PersonListViewModel? {
        didSet {
            viewModel?.viewDelegate = self
            title = viewModel?.title
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        personListTableView.delegate = self
        personListTableView.dataSource = viewModel
        personListSearchBar.delegate = viewModel
        addPersonBarButton = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(addPersonButtonTapped))
        settingsBarButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(openSettings))
        navigationItem.leftBarButtonItems = [addPersonBarButton]
        navigationItem.rightBarButtonItems = [settingsBarButton]
    }
    override func viewDidAppear(_ animated: Bool) {
        viewModel?.fetchPeople()
        viewModel?.getRegularity()
        personListTableView.reloadData()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    @objc func addPersonButtonTapped() {
        viewModel?.addPerson()
    }
    @objc func openSettings() {
        viewModel?.openSettings()
    }
}
extension PersonListViewController: PersonListViewModelDelegate {
    func personListViewModelDidUpdateTableData(_ personListViewModel: PersonListViewModel) {
        personListTableView.reloadData()
    }
}
extension PersonListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
            self.viewModel?.removePerson(at: indexPath.row)
            self.viewModel?.fetchPeople()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //viewModel?.addInteraction(with: indexPath.row)
        viewModel?.didSelectPerson(at: indexPath.row)
    }
}

