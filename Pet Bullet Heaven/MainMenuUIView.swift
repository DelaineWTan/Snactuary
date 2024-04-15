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
    var statsButtonTappedHandler: (() -> Void)?
    var exitButtonTappedHandler: (() -> Void)?
    
    lazy var titleLabel: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "title_image.png")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var playButton: UIButton = {
        let button = Utilities.makeButton(title: "Play", image: UIImage(named: "cloud_teal.png"), backgroundColor: .blue, target: self, action: #selector(playButtonTapped))
        return button
    }()
    
    lazy var selectPetsButton: UIButton = {
        let button = Utilities.makeButton(title: "Select Pets", image: UIImage(named: "cloud_yellow.png"), backgroundColor: .blue, target: self, action: #selector(selectPetsButtonTapped))
        return button
    }()
    
    lazy var statsButton: UIButton = {
        let button = Utilities.makeButton(title: "Statistics", image: UIImage(named: "cloud_teal.png"), backgroundColor: .blue, target: self, action: #selector(statsButtonTapped))
        return button
    }()
    
    lazy var exitButton: UIButton = {
        let button = Utilities.makeButton(title: "Exit", image: UIImage(named: "cloud_pink.png"), backgroundColor: .red, target: self, action: #selector(exitButtonTapped))
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
        addSubview(statsButton)
        addSubview(exitButton)
        
        // Layout constraints for title image
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),            
            titleLabel.widthAnchor.constraint(equalToConstant: 300),
            titleLabel.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        // Layout constraints for buttons
        playButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -60), // Shifted up by 40 points
            playButton.widthAnchor.constraint(equalToConstant: 147),
            playButton.heightAnchor.constraint(equalToConstant: 98)
        ])
        
        selectPetsButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectPetsButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            selectPetsButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 60), // Centered vertically
            selectPetsButton.widthAnchor.constraint(equalToConstant: 147),
            selectPetsButton.heightAnchor.constraint(equalToConstant: 98)
        ])
        
        statsButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statsButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            statsButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 180), // Shifted down by 40 points
            statsButton.widthAnchor.constraint(equalToConstant: 147),
            statsButton.heightAnchor.constraint(equalToConstant: 98)
        ])
        
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            exitButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            exitButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 300), // Shifted down by 80 points
            exitButton.widthAnchor.constraint(equalToConstant: 147),
            exitButton.heightAnchor.constraint(equalToConstant: 98)
        ])
    }
    
    @objc private func playButtonTapped() {
        playButtonTappedHandler?()
    }
    
    @objc private func selectPetsButtonTapped() {
        selectPetsButtonTappedHandler?()
    }
    
    @objc private func statsButtonTapped() {
        statsButtonTappedHandler?()
    }
    
    @objc private func exitButtonTapped() {
        exitButtonTappedHandler?()
    }
}

