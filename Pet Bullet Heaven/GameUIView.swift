//
//  GameUIView.swift
//  Pet Bullet Heaven
//
//  Created by Delaine on 2024-02-08.
//  This is the UI that overlays the game scene.
//


import UIKit

class GameUIView: UIView {
    let mainMenuUIView = MainMenuUIView()
    let petSelectionUIView = PetSelectionUIView()
    let pauseMenuUIView = PauseMenuUIView()
    let inGameUIView = InGameUIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(mainMenuUIView)
        // Initially the other UI views
        addSubview(petSelectionUIView)
        petSelectionUIView.isHidden = true
        addSubview(pauseMenuUIView)
        pauseMenuUIView.isHidden = true
        addSubview(inGameUIView)
        inGameUIView.isHidden = true
        
        // Layout constraints for main menu view
        mainMenuUIView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainMenuUIView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainMenuUIView.centerYAnchor.constraint(equalTo: centerYAnchor),
            mainMenuUIView.widthAnchor.constraint(equalTo: widthAnchor),
            mainMenuUIView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
        setupMainMenuHandlers()
        
        // Layout constraints for pause menu view
        pauseMenuUIView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pauseMenuUIView.centerXAnchor.constraint(equalTo: centerXAnchor),
            pauseMenuUIView.centerYAnchor.constraint(equalTo: centerYAnchor),
            pauseMenuUIView.widthAnchor.constraint(equalTo: widthAnchor),
            pauseMenuUIView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
        setupPauseMenuHandlers()
        
        // Layout constraints for pet selection view
        petSelectionUIView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            petSelectionUIView.centerXAnchor.constraint(equalTo: centerXAnchor),
            petSelectionUIView.centerYAnchor.constraint(equalTo: centerYAnchor),
            petSelectionUIView.widthAnchor.constraint(equalTo: widthAnchor),
            petSelectionUIView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
        setupPetSelectionMenuHandlers()
        
        // Layout constraints for in game view
        inGameUIView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inGameUIView.centerXAnchor.constraint(equalTo: centerXAnchor),
            inGameUIView.centerYAnchor.constraint(equalTo: centerYAnchor),
            inGameUIView.widthAnchor.constraint(equalTo: widthAnchor),
            inGameUIView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
        setupInGameUIHandlers()
    }
    
    private func setupMainMenuHandlers() {
        mainMenuUIView.playButtonTappedHandler = { [weak self] in
            // Hide main menu and show in-game overlay
            self?.mainMenuUIView.isHidden = true
            self?.inGameUIView.isHidden = false
        }
        
        mainMenuUIView.selectPetsButtonTappedHandler = { [weak self] in
            // Hide main menu and show pet selection menu
            self?.mainMenuUIView.isHidden = true
            self?.petSelectionUIView.isHidden = false
        }
        
        mainMenuUIView.exitButtonTappedHandler = {
            exit(0)
        }
    }
    
    private func setupPetSelectionMenuHandlers() {
        petSelectionUIView.mainMenuButtonTappedHandler = { [weak self] in
            // Hide pet selection menu and show main menu
            self?.mainMenuUIView.isHidden = false
            self?.petSelectionUIView.isHidden = true
        }
    }
    
    private func setupPauseMenuHandlers() {
        pauseMenuUIView.mainMenuButtonTappedHandler = { [weak self] in
            // Hide pause menu and show main menu
            self?.pauseMenuUIView.isHidden = true
            self?.mainMenuUIView.isHidden = false
        }
    }
    
    private func setupInGameUIHandlers() {
        inGameUIView.pauseButtonTappedHandler = { [weak self] in
            // Hide in game ui and show pause menu
            self?.pauseMenuUIView.isHidden = false
            self?.inGameUIView.isHidden = true
        }
    }
}

