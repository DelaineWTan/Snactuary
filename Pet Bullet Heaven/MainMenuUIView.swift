//
//  MainMenuUIView.swift
//  Pet Bullet Heaven
//
//  Created by Delaine on 2024-02-08.
//

import UIKit

class MainMenuUIView: UIView {
    var playButtonTappedHandler: (() -> Void)?
    var selectPetsButtonTappedHandler: (() -> Void)?
    var exitButtonTappedHandler: (() -> Void)?
    
    lazy var titleLabel: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "title_image.png")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var playButton: UIButton = {
        let button = Utilities.makeButton(title: "Play", image: nil, backgroundColor: .blue, target: self, action: #selector(playButtonTapped))
        return button
    }()
    
    lazy var selectPetsButton: UIButton = {
        let button = Utilities.makeButton(title: "Select Pets", image: nil, backgroundColor: .blue, target: self, action: #selector(selectPetsButtonTapped))
        return button
    }()
    
    lazy var exitButton: UIButton = {
        let button = Utilities.makeButton(title: "Exit", image: nil, backgroundColor: .red, target: self, action: #selector(exitButtonTapped))
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
        addSubview(titleLabel)
        addSubview(playButton)
        addSubview(selectPetsButton)
        addSubview(exitButton)
        
        // Layout constraints for title image
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),            titleLabel.widthAnchor.constraint(equalToConstant: 300),
            titleLabel.heightAnchor.constraint(equalToConstant: 200)
        ])
        
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

