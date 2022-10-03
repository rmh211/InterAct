//
//  SettingsViewController.swift
//  InterAct
//
//  Created by Robert Huber on 9/30/22.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var regularityPickerView: UIPickerView! {
        didSet {
            regularityPickerView.dataSource = viewModel
            regularityPickerView.delegate = self
        }
    }
    @IBOutlet weak var saveButton: UIButton!
    var viewModel: SettingsViewModel? {
        didSet {
            viewModel?.viewDelegate = self
            title = viewModel?.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        let regularityIndex = regularityPickerView.selectedRow(inComponent: 0)
        viewModel?.saveSettings(regularityIndex)
    }
    
}
extension SettingsViewController: SettingsViewModelDelegate {
    
}
extension SettingsViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        viewModel?.regularity[row]
    }
}
