//
//  PetSelectionUIView.swift
//  Pet Bullet Heaven
//
//  Created by Delaine on 2024-02-08.
//
import UIKit
import SwiftUI
import Combine

class PetSelectionViewModel: ObservableObject {
    @Published var activePets:[Pet] = Globals.activePets
    @Published var allPets:[Pet] = Globals.allPets
}

class PetSelectionUIView: UIView {
    let viewModel = PetSelectionViewModel()
    
    var selectedPet: Pet?
    var selectedPetButton: UIButton?
    
    var mainMenuButtonTappedHandler: (() -> Void)?
    
    lazy var mainMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Main Menu", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.tintColor = .white
        button.backgroundColor = .blue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(mainMenuButtonTapped), for: .touchUpInside)
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
            mainMenuButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            mainMenuButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            mainMenuButton.widthAnchor.constraint(equalToConstant: 100),
            mainMenuButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        // Active Pets
        var yPosition: CGFloat = 200 // Initial Y position for the active pets section
        for pet in viewModel.activePets {
            let button = UIButton(type: .system)
            button.setTitle(pet.name, for: .normal)
            button.backgroundColor = .blue
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 8
            button.addTarget(self, action: #selector(petButtonTapped(_:)), for: .touchUpInside)
            button.frame = CGRect(x: 20, y: yPosition, width: 200, height: 40) // Adjust frame as needed
            addSubview(button)
            yPosition += 50 // Increment Y position for the next button
        }
        
        // Pet Collection
        yPosition += 20 // Add some spacing between sections
        for pet in viewModel.allPets {
            let button = UIButton(type: .system)
            button.setTitle(pet.name, for: .normal)
            button.backgroundColor = .green
            button.setTitleColor(.black, for: .normal)
            button.layer.cornerRadius = 8
            button.addTarget(self, action: #selector(petButtonTapped(_:)), for: .touchUpInside)
            button.frame = CGRect(x: 20, y: yPosition, width: 200, height: 40) // Adjust frame as needed
            addSubview(button)
            yPosition += 50 // Increment Y position for the next button
        }
    }
    
    @objc private func mainMenuButtonTapped() {
        mainMenuButtonTappedHandler?()
    }
    
    func updateButtonTitles() {
        // Update active pet buttons
        for (index, pet) in viewModel.activePets.enumerated() {
            if let button = viewWithTag(1000 + index) as? UIButton {
                button.setTitle(pet.name, for: .normal)
            }
        }
        // Update collection pet buttons
        for (index, pet) in viewModel.allPets.enumerated() {
            if let button = viewWithTag(2000 + index) as? UIButton {
                button.setTitle(pet.name, for: .normal)
            }
        }
    }
    @objc private func petButtonTapped(_ sender: UIButton) {
        if let petName = sender.title(for: .normal),
           let pet = viewModel.allPets.first(where: { $0.name == petName }) ?? viewModel.activePets.first(where: { $0.name == petName }) {
            
            if let selectedPet = selectedPet,
               let petIndex = viewModel.allPets.firstIndex(where: { $0.name == petName }) ?? viewModel.activePets.firstIndex(where: { $0.name == petName }),
               let selectedIndex = viewModel.allPets.firstIndex(where: { $0.name == selectedPet.name }) ?? viewModel.activePets.firstIndex(where: { $0.name == selectedPet.name }) {
                
                viewModel.allPets.swapAt(petIndex, selectedIndex)
                viewModel.activePets.swapAt(petIndex, selectedIndex)
                
                // Update the UI
                sender.setTitle(selectedPet.name, for: .normal)
                selectedPetButton?.setTitle(petName, for: .normal)
            }
            
            selectedPet = pet
            selectedPetButton = sender
            print("Selected pet: \(petName)")
        }
    }
}
