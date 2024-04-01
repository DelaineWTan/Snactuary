//
//  PauseMenuUIView.swift
//  Pet Bullet Heaven
//
//  Created by Delaine on 2024-02-08.
//
import UIKit

class PauseMenuUIView: UIView {
    var mainMenuButtonTappedHandler: (() -> Void)?
    
    lazy var mainMenuButton: UIButton = {
        let button = Utilities.makeButton(title: "Main Menu", image: UIImage(named: "cloud_pink.png"), backgroundColor: .blue, target: self, action: #selector(mainMenuButtonTapped))
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(mainMenuButton)
        
        // Layout constraints for buttons
        mainMenuButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainMenuButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainMenuButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 20),
            mainMenuButton.widthAnchor.constraint(equalToConstant: 147),
            mainMenuButton.heightAnchor.constraint(equalToConstant: 98)
        ])
    }
    
    @objc private func mainMenuButtonTapped() {
        mainMenuButtonTappedHandler?()
    }
}



