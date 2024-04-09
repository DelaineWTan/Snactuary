//
//  FloatingDamageText.swift
//  Pet Bullet Heaven
//
//  Created by Delaine on 2024-03-25.
//

import UIKit

class FloatingText: UILabel {
    func showDamageText(at position: CGPoint, with damage: Int) {
        self.text = "\(damage)"
        self.textColor = UIColor(hex: 0x37dfcd)
        self.font = UIFont.boldSystemFont(ofSize: 24)
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
    
    func showLevelUpText(at position: CGPoint, with level: Int) {
        self.text = "LVL \(level)!"
        self.textColor = UIColor(hex: 0xdaff20)
        self.font = UIFont.boldSystemFont(ofSize: 24)
        self.sizeToFit()
        self.alpha = 1.0
        self.center = position

        // Animate floating and fading out
        UIView.animate(withDuration: 2.0, animations: {
            self.center.y -= 50
            self.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
}
