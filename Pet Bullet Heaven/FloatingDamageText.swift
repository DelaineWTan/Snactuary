//
//  FloatingDamageText.swift
//  Pet Bullet Heaven
//
//  Created by Delaine on 2024-03-25.
//

import UIKit

class FloatingDamageText: UILabel {
    func showDamageText(at position: CGPoint, with damage: Int) {
        self.text = "-\(damage)"
        self.textColor = UIColor.red
        self.font = UIFont.boldSystemFont(ofSize: 20)
        self.sizeToFit()
        self.alpha = 1.0
        self.center = position

        // Animate floating and fading out
        UIView.animate(withDuration: 1.0, animations: {
            self.center.y -= 50
            self.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
}
