//
//  PauseMenuUIView.swift
//  Pet Bullet Heaven
//
//  Created by Delaine on 2024-02-08.
//
import UIKit

class PauseMenuUIView: UIView {
    var resumeButtonTappedHandler: (() -> Void)?
    var mainMenuButtonTappedHandler: (() -> Void)?
    
    lazy var resumeButton: UIButton = {
        let button = Utilities.makeButton(title: "Resume", image: UIImage(named: "cloud_teal.png"), backgroundColor: .blue, target: self, action: #selector(resumeButtonTapped))
        return button
    }()
    
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
        addSubview(resumeButton)
        addSubview(mainMenuButton)
        
        // Layout constraints for buttons
        resumeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resumeButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            resumeButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -60),
            resumeButton.widthAnchor.constraint(equalToConstant: 147),
            resumeButton.heightAnchor.constraint(equalToConstant: 98)
        ])
        mainMenuButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainMenuButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainMenuButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 60),
            mainMenuButton.widthAnchor.constraint(equalToConstant: 147),
            mainMenuButton.heightAnchor.constraint(equalToConstant: 98)
        ])
    }
    
    @objc private func resumeButtonTapped() {
        resumeButtonTappedHandler?()
    }
    
    @objc private func mainMenuButtonTapped() {
        mainMenuButtonTappedHandler?()
    }
}



