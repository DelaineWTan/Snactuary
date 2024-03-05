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
    @Published var allPets: [Pet] = Globals.pets
    
    var activePets: [Pet] {
        get {
            Array(allPets.prefix(4))
        }
        set {
            // Update the first four elements of allPets with the new active pets
            for (index, pet) in newValue.enumerated() {
                if index < 4 {
                    allPets[index] = pet
                }
            }
        }
    }
}

class PetSelectionUIView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let viewModel = PetSelectionViewModel()
    let cellIdentifier = "PetCell"
    
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
    
    // Define views
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var collectionView: UICollectionView = {
           let layout = UICollectionViewFlowLayout()
           layout.scrollDirection = .horizontal
           
           let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
           collectionView.dataSource = self
           collectionView.delegate = self
           collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
           collectionView.backgroundColor = .clear
           return collectionView
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
          addSubview(collectionView)
          collectionView.translatesAutoresizingMaskIntoConstraints = false
          NSLayoutConstraint.activate([
              collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
              collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
              collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
              collectionView.heightAnchor.constraint(equalToConstant: 120) // Adjust height as needed
          ])
      }
      
      func numberOfSections(in collectionView: UICollectionView) -> Int {
          return 2
      }
      
      func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          if section == 0 {
              return viewModel.activePets.count
          } else {
              return viewModel.allPets.count
          }
      }
      
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
          cell.backgroundColor = .green
          
          // Add button or text label to cell
          let label = UILabel()
          label.text = indexPath.section == 0 ? viewModel.activePets[indexPath.item].name : viewModel.allPets[indexPath.item].name
          label.textAlignment = .center
          label.translatesAutoresizingMaskIntoConstraints = false
          cell.contentView.addSubview(label)
          
          NSLayoutConstraint.activate([
              label.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
              label.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
          ])
          
          return cell
      }
      
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          return CGSize(width: 80, height: 80) // Adjust size as needed
      }
    
    @objc private func mainMenuButtonTapped() {
        mainMenuButtonTappedHandler?()
    }
    
    @objc private func petButtonTapped(_ sender: UIButton) {
        guard let petName = sender.title(for: .normal),
              let pet = viewModel.allPets.first(where: { $0.name == petName }) ?? viewModel.activePets.first(where: { $0.name == petName }) else {
            return
        }
        
        // If no pet is selected, set the current pet and return
        if selectedPet == nil {
            selectedPet = pet
            selectedPetButton = sender
            return
        }
        
        // If the same button is tapped again, reset the selection
        if selectedPetButton === sender {
            selectedPet = nil
            selectedPetButton = nil
            return
        }
        
        if let selectedPet = selectedPet,
           let petIndex = viewModel.allPets.firstIndex(where: { $0.name == petName }) ?? viewModel.activePets.firstIndex(where: { $0.name == petName }),
           let selectedIndex = viewModel.allPets.firstIndex(where: { $0.name == selectedPet.name }) ?? viewModel.activePets.firstIndex(where: { $0.name == selectedPet.name }) {
            
            // Swap pets in allPets array
            if let allPetIndex = viewModel.allPets.firstIndex(where: { $0.name == petName }) {
                viewModel.allPets.swapAt(allPetIndex, selectedIndex)
            }
            
            // Swap pets in activePets array
            if let activePetIndex = viewModel.activePets.firstIndex(where: { $0.name == petName }) {
                viewModel.activePets.swapAt(activePetIndex, selectedIndex)
            }
            
            // Update the UI
            sender.setTitle(selectedPet.name, for: .normal)
            selectedPetButton?.setTitle(petName, for: .normal)
        }
        
        selectedPet = pet
        selectedPetButton = sender
        print("Selected pet: \(petName)")
    }
}
