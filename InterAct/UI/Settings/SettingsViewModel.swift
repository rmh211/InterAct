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
    func settingsViewControllerDidSaveSettings(_ settingViewModel:SettingsViewModel)
    
}
protocol SettingsViewModelDelegate: AnyObject {
    
}

class SettingsViewModel: NSObject {
    weak var coordinatorDelegate: SettingsViewModelCoordinatorDelegate?
    weak var viewDelegate: SettingsViewModelDelegate?
    var defaults = UserDefaults.standard
    var title = "Settings"
    let regularity = ["Weekly", "2 Weeks", "Monthly", "2 Months", "6 Months", "Yearly"]
    func saveSettings(_ index: Int) {
        defaults.set(index, forKey: "Regularity")
        coordinatorDelegate?.settingsViewControllerDidSaveSettings(self)
    }
}
extension SettingsViewModel: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return regularity.count
    }
}
