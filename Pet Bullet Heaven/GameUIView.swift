//
//  OverlayView.swift
//  Pet Bullet Heaven
//
//  Created by Delaine on 2024-02-08.
//  This is the UI that overlays the game scene.
//


import UIKit

class GameUIView: UIView {
    let mainMenuView = MainMenuUIView()
    let petSelectionView = PetSelectionUIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(mainMenuView)
        // Initially hide pet selection view
        addSubview(petSelectionView)
        petSelectionView.isHidden = true
        
        // Layout constraints for main menu view
        mainMenuView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainMenuView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainMenuView.centerYAnchor.constraint(equalTo: centerYAnchor),
            mainMenuView.widthAnchor.constraint(equalTo: widthAnchor),
            mainMenuView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
        setupMainMenuHandlers()
        
        // Layout constraints for pet selection view
        petSelectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            petSelectionView.centerXAnchor.constraint(equalTo: centerXAnchor),
            petSelectionView.centerYAnchor.constraint(equalTo: centerYAnchor),
            petSelectionView.widthAnchor.constraint(equalTo: widthAnchor),
            petSelectionView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
        setupPetSelectionMenuHandlers()
    }
    
    private func setupMainMenuHandlers() {
        mainMenuView.playButtonTappedHandler = { [weak self] in
            // Hide main menu and show in-game overlay
            self?.mainMenuView.isHidden = true
        }
        
        mainMenuView.selectPetsButtonTappedHandler = { [weak self] in
            // Hide main menu and show pet selection menu
            self?.mainMenuView.isHidden = true
            self?.petSelectionView.isHidden = false
        }
        
        mainMenuView.exitButtonTappedHandler = {
            // Exit game
            exit(0)
        }
    }
    
    private func setupPetSelectionMenuHandlers() {
        petSelectionView.mainMenuButtonTappedHandler = { [weak self] in
            // Hide pet selection menu and show main menu
            self?.mainMenuView.isHidden = false
            self?.petSelectionView.isHidden = true
        }
    }
}

