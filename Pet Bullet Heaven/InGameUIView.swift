//
//  InGameUIView.swift
//  Pet Bullet Heaven
//
//  Created by Delaine on 2024-02-08.
//

import UIKit

class InGameUIView: UIView {
    var pauseButtonTappedHandler: (() -> Void)?
    
    lazy var pauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Pause", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.tintColor = .white
        button.backgroundColor = .blue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
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
        addSubview(pauseButton)
        
        // Layout constraints for pause button
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pauseButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            pauseButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            pauseButton.widthAnchor.constraint(equalToConstant: 100),
            pauseButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func pauseButtonTapped() {
        pauseButtonTappedHandler?()
    }
}
