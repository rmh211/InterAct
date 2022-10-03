//
//  InteractionTableViewCell.swift
//  InterAct
//
//  Created by Robert Huber on 10/2/22.
//

import UIKit

class InteractionTableViewCell: UITableViewCell {
 
    @IBOutlet weak var interactionView: UIView! {
        didSet {
            interactionView.layer.cornerRadius = 5
            interactionView.backgroundColor = .systemGray6
        }
    }
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            dateLabel.font = .systemFont(ofSize: 25, weight: .light)
        }
    }
    @IBOutlet weak var qualityLabel: UILabel! {
        didSet {
            qualityLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
