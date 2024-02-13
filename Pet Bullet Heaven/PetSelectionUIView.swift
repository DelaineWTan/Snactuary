//
//  PetSelectionUIView.swift
//  Pet Bullet Heaven
//
//  Created by Delaine on 2024-02-08.
//
import UIKit
import SwiftUI
import Combine

struct Pet {
    let id: Int
    var name: String
    // might need more properties yea
}

class PetSelectionViewModel: ObservableObject {
    @Published var activePets: [Pet] = [
        Pet(id: 1, name: "Bunni"),
        Pet(id: 2, name: "Frogger"),
        Pet(id: 3, name: "Ticken"),
        Pet(id: 4, name: "Foxxy")
    ]
    
    @Published var allPets: [Pet] = [
        Pet(id: 5, name: "Horze"),
        Pet(id: 6, name: "Furret"),
        Pet(id: 7, name: "Krockerdile"),
        Pet(id: 8, name: "Pengwin")
        // Add more pets as needed
    ]
}

class PetSelectionUIView: UIView {
    let viewModel = PetSelectionViewModel()
    
    var selectedActivePet: Pet?
    var selectedCollectionPet: Pet?
    
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
            button.addTarget(self, action: #selector(activePetButtonTapped(_:)), for: .touchUpInside)
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
            button.addTarget(self, action: #selector(collectionPetButtonTapped(_:)), for: .touchUpInside)
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
    @objc private func activePetButtonTapped(_ sender: UIButton) {
            if let petName = sender.title(for: .normal), let pet = viewModel.activePets.first(where: { $0.name == petName }) {
                if let selectedPet = selectedActivePet {
                    // Swap pets
                    if let index1 = viewModel.activePets.firstIndex(where: { $0.name == petName }),
                       let index2 = viewModel.activePets.firstIndex(where: { $0.name == selectedPet.name }) {
                        viewModel.activePets.swapAt(index1, index2)
                        selectedActivePet = nil
                        updateButtonTitles() // Update button titles after swapping
                        print("Swapped: \(selectedPet.name) with \(pet.name)")
                    }
                } else {
                    selectedActivePet = pet
                    print("Selected active pet: \(petName)")
                }
            }
        }

        @objc private func collectionPetButtonTapped(_ sender: UIButton) {
            if let petName = sender.title(for: .normal), let pet = viewModel.allPets.first(where: { $0.name == petName }) {
                if let selectedPet = selectedCollectionPet {
                    // Swap pets
                    if let index1 = viewModel.allPets.firstIndex(where: { $0.name == petName }),
                       let index2 = viewModel.allPets.firstIndex(where: { $0.name == selectedPet.name }) {
                        viewModel.allPets.swapAt(index1, index2)
                        selectedCollectionPet = nil
                        updateButtonTitles() // Update button titles after swapping
                        print("Swapped: \(selectedPet.name) with \(pet.name)")
                    }
                } else {
                    selectedCollectionPet = pet
                    print("Selected collection pet: \(petName)")
                }
            }
        }
}
