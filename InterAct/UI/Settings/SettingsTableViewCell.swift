//
//  SettingsTableViewCell.swift
//  InterAct
//
//  Created by Robert Huber on 10/3/22.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var settingStackView: UIStackView!
    @IBOutlet weak var settingNameLabel: UILabel! {
        didSet {
            settingNameLabel.font = .systemFont(ofSize: 20, weight: .medium)
        }
    }
    @IBOutlet weak var settingDescriptionLabel: UILabel! {
        didSet {
            settingDescriptionLabel.font = .italicSystemFont(ofSize: 15)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
