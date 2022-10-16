//
//  SettingsViewController.swift
//  InterAct
//
//  Created by Robert Huber on 9/30/22.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var settingsTableView: UITableView!
    var viewModel: SettingsViewModel? {
        didSet {
            viewModel?.viewDelegate = self
            title = viewModel?.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTableView.delegate = self
        settingsTableView.dataSource = viewModel
    }

}
extension SettingsViewController: SettingsViewModelDelegate {
    
}
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelectSetting(at: indexPath.row)
    }
}
