//
//  SettingsViewModel.swift
//  InterAct
//
//  Created by Robert Huber on 9/30/22.
//

import Foundation
import UIKit
protocol SettingsViewModelCoordinatorDelegate: AnyObject {
    func settingsViewController()
    func settingsViewControllerDidSaveSettings(_ settingViewModel: SettingsViewModel)
    func settingsViewControllerDidSelectFrequency(_ settingsViewModel: SettingsViewModel)
    
}
protocol SettingsViewModelDelegate: AnyObject {
    
}

class SettingsViewModel: NSObject {
    weak var coordinatorDelegate: SettingsViewModelCoordinatorDelegate?
    weak var viewDelegate: SettingsViewModelDelegate?
    var defaults = UserDefaults.standard
    var title = "Settings"
    let settingsTitles = ["Frequency"]
    let settings: [String: String] = ["Frequency": "How often you want to connect"]
    func saveSettings(_ index: Int) {
        defaults.set(index, forKey: "Regularity")
        coordinatorDelegate?.settingsViewControllerDidSaveSettings(self)
    }
    func didSelectSetting(at settingIndex: Int) {
        switch settingIndex {
        case 0:
            coordinatorDelegate?.settingsViewControllerDidSelectFrequency(self)
        default:
            print("No Such Setting")
        }
    }
}
extension SettingsViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as? SettingsTableViewCell else { return UITableViewCell() }
        cell.settingNameLabel.text = settingsTitles[indexPath.row]
        cell.settingDescriptionLabel.text = settings[settingsTitles[indexPath.row]]
        return cell
    }
}
