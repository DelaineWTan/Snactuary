//
//  MainMenuView.swift
//  Pet Bullet Heaven
//
//  Created by Delaine on 2024-02-08.
//

import UIKit

class MainMenuUIView: UIView {
    var playButtonTappedHandler: (() -> Void)?
    var selectPetsButtonTappedHandler: (() -> Void)?
    var exitButtonTappedHandler: (() -> Void)?
    
    lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Play", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.tintColor = .white
        button.backgroundColor = .blue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var selectPetsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Pets", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.tintColor = .white
        button.backgroundColor = .blue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(selectPetsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var exitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Exit", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.tintColor = .white
        button.backgroundColor = .red
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
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
        addSubview(playButton)
        addSubview(selectPetsButton)
        addSubview(exitButton)
        
        // Layout constraints for buttons
        playButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -40), // Shifted up by 40 points
            playButton.widthAnchor.constraint(equalToConstant: 100),
            playButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        selectPetsButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectPetsButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            selectPetsButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 20), // Centered vertically
            selectPetsButton.widthAnchor.constraint(equalToConstant: 100),
            selectPetsButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            exitButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            exitButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 80), // Shifted down by 40 points
            exitButton.widthAnchor.constraint(equalToConstant: 100),
            exitButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func playButtonTapped() {
        playButtonTappedHandler?()
    }
    
    @objc private func selectPetsButtonTapped() {
        selectPetsButtonTappedHandler?()
    }
    
    @objc private func exitButtonTapped() {
        exitButtonTappedHandler?()
    }
}

