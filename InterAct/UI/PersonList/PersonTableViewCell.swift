//
//  PersonTableViewCell.swift
//  InterAct
//
//  Created by Robert Huber on 9/29/22.
//

import UIKit

class PersonTableViewCell: UITableViewCell {

    @IBOutlet weak var alertIconImageView: UIImageView!
    @IBOutlet weak var personView: UIView!{
        didSet {
            personView.layer.cornerRadius = 15
            personView.backgroundColor = .systemGray5
        }
    }
    @IBOutlet weak var portraitImageView: UIImageView! {
        didSet {
            portraitImageView.contentMode = .scaleAspectFill
            portraitImageView.makeRound()
        }
    }
    @IBOutlet weak var lastInteractionDateLabel: UILabel! {
        didSet {
            lastInteractionDateLabel.font = .preferredFont(forTextStyle: .subheadline)
        }
    }
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.font = .systemFont(ofSize: 20, weight: .medium)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
