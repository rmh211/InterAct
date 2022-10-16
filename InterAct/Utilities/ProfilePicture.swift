//
//  ProfilePicture.swift
//  InterAct
//
//  Created by Robert Huber on 9/30/22.
//

import Foundation
import UIKit

extension UIImageView {
    func makeRound() {
        layer.borderWidth = 1
        layer.masksToBounds = false
        layer.borderColor = UIColor.systemGray6.cgColor
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
}
