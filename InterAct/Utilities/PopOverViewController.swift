//
//  PopOverViewController.swift
//  InterAct
//
//  Created by Robert Huber on 10/6/22.
//

import UIKit

class PopOverViewController: UIViewController {
    var mainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView = UIView()
        
    }
    func makeBackgroundBlurred() {
        if !UIAccessibility.isReduceTransparencyEnabled {
            view.backgroundColor = .clear

            let blurEffect = UIBlurEffect(style: .light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            view.addSubview(blurEffectView)
        } else {
            view.backgroundColor = .black
        }
    }
    func createFloatingView(withBackgroundColor bgColor: UIColor, andBorderColor bdColor: UIColor = .clear, height: CGFloat, width: CGFloat, xOffset: CGFloat = 0, yOffset: CGFloat = 0, alignment: PopOverAlignment = .center, withXPadding xPadding: CGFloat = 35, withYPadding yPadding: CGFloat = 35) {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let frameWidth = width > screenWidth ? screenWidth - 10 : width
        let frameHeight = height > screenHeight - 300 ? screenHeight - 100 : height
        var frameX = ((screenWidth - frameWidth) / 2) + xOffset
        var frameY = ((screenHeight - frameHeight) / 2) - yOffset
        if xOffset == 0 && yOffset == 0 {
            switch alignment {
            case .center:
                frameX = ((screenWidth - frameWidth) / 2) + xOffset
                frameY = ((screenHeight - frameHeight) / 2) - yOffset
            case .topLeft:
                frameX = xPadding
                frameY = yPadding + 35
            case .topRight:
                frameX = screenWidth - (frameWidth + xPadding)
                frameY = yPadding + 35
            case .bottom:
                frameX = ((screenWidth - frameWidth) / 2) + xOffset
                frameY = (screenHeight - frameHeight) - yPadding - 10
            case .top:
                frameX = ((screenWidth - frameWidth) / 2) + xOffset
                frameY = yPadding + 35
            case .bottomLeft:
                frameX = xPadding
                frameY = screenHeight - (frameHeight + yPadding) - 10
            case .bottomRight:
                frameX = screenWidth - (frameWidth + xPadding)
                frameY = screenHeight - (frameHeight + yPadding) - 10
            }
        }
    
        let frame = CGRect(x: frameX, y: frameY, width: frameWidth, height: frameHeight)
        mainView = UIView(frame: frame)
        mainView.backgroundColor = bgColor
        mainView.layer.borderWidth = 5
        mainView.layer.borderColor = bdColor.cgColor
        mainView.layer.cornerRadius = 20
        view.addSubview(mainView)
    }
}
enum PopOverAlignment {
    case center
    case topLeft
    case topRight
    case bottom
    case top
    case bottomLeft
    case bottomRight
}

