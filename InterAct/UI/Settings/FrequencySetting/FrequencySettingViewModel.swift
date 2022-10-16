//
//  FrequencySettingViewModel.swift
//  InterAct
//
//  Created by Robert Huber on 10/3/22.
//

import Foundation
import UIKit
protocol FrequencyViewModelCoordinatorDelegate: AnyObject {
    func frequencyViewController()
    func frequencyViewControllerDidSelectFrequencsy(_ frequencyViewModel: FrequencyViewModel)
}
protocol FrequencyViewModelDelegate: AnyObject {
    func frequenceyViewModel(_ frequencyViewModel: FrequencyViewModel, willSetFrequencyAsActive frequency: Int)
}

class FrequencyViewModel: NSObject {
    weak var coordinatorDelegate: FrequencyViewModelCoordinatorDelegate?
    weak var viewDelegate: FrequencyViewModelDelegate?
    let frequencies = ["Weekly", "Two Weeks", "Monthly", "Two Months", "Six Months", "Yearly"]
    var title = "Frequency"
    let defaults = UserDefaults.standard
    func saveFrequencySetting(of frequencySetting: Int) {
        defaults.set(frequencySetting, forKey: "Frequency")
        coordinatorDelegate?.frequencyViewControllerDidSelectFrequencsy(self)
    }
    func selectSavedRow() {
        guard let selection = defaults.object(forKey: "Frequency") as? Int else { return }
        viewDelegate?.frequenceyViewModel(self, willSetFrequencyAsActive: selection)
    }
}
extension FrequencyViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frequencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FrequencyCell", for: indexPath) as? FrequencyTableViewCell else { return UITableViewCell()}
        cell.frequencyLabel.text = frequencies[indexPath.row]
        return cell
    }
}
