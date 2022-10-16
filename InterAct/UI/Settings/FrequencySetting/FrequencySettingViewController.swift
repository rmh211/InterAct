//
//  FrequencySettingViewController.swift
//  InterAct
//
//  Created by Robert Huber on 10/3/22.
//

import UIKit

class FrequencySettingViewController: UIViewController {
    
    @IBOutlet weak var frequencySettingTableView: UITableView!
    var viewModel: FrequencyViewModel? {
        didSet {
            title = viewModel?.title
            viewModel?.viewDelegate = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        frequencySettingTableView.delegate = self
        frequencySettingTableView.dataSource = viewModel
    }
    override func viewDidAppear(_ animated: Bool) {
        viewModel?.selectSavedRow()
    }
    
}
extension FrequencySettingViewController: FrequencyViewModelDelegate {
    func frequenceyViewModel(_ frequencyViewModel: FrequencyViewModel, willSetFrequencyAsActive frequency: Int) {
        frequencySettingTableView.selectRow(at: IndexPath(row: frequency, section: 0), animated: false, scrollPosition: .none)
        
    }
    
    
}
extension FrequencySettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.saveFrequencySetting(of: indexPath.row)
    }
}
