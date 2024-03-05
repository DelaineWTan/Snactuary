//  PetSelectionUIView.swift
//  Pet Bullet Heaven
//
//  Created by Delaine on 2024-02-08.
//
import UIKit
import SwiftUI
import Combine

class PetSelectionUIView: UIView {
    var selectedPanel: UIView?
    var selectedPet: Pet?
    
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

    // active pet panels
    let topLeftPanel = UIView()
    let topRightPanel = UIView()
    let bottomLeftPanel = UIView()
    let bottomRightPanel = UIView()
    // collection pet panels
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupCollectionPanels()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupCollectionPanels()
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
        
        // Create stack views for top and bottom rows
        let topRowStackView = UIStackView()
        topRowStackView.axis = .horizontal
        topRowStackView.spacing = 20
        topRowStackView.alignment = .fill
        topRowStackView.distribution = .fillEqually
        topRowStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomRowStackView = UIStackView()
        bottomRowStackView.axis = .horizontal
        bottomRowStackView.spacing = 20
        bottomRowStackView.alignment = .fill
        bottomRowStackView.distribution = .fillEqually
        bottomRowStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add panels to stack views
        topRowStackView.addArrangedSubview(topLeftPanel)
        topRowStackView.addArrangedSubview(topRightPanel)
        bottomRowStackView.addArrangedSubview(bottomLeftPanel)
        bottomRowStackView.addArrangedSubview(bottomRightPanel)
        
        // Add stack views to main stack view
        let mainStackView = UIStackView(arrangedSubviews: [topRowStackView, bottomRowStackView])
        mainStackView.axis = .vertical
        mainStackView.spacing = 40 // spacing between each of the active panels
        mainStackView.alignment = .fill
        mainStackView.distribution = .fillEqually
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            mainStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5), // Adjust width and length as needed
            mainStackView.heightAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 1.0) // Maintain aspect ratio
        ])
        
        // Customize panel appearance
        [topLeftPanel, topRightPanel, bottomLeftPanel, bottomRightPanel].forEach {
            $0.backgroundColor = .lightGray
            $0.layer.cornerRadius = 8
        }
        
        // Adding active pet panels
        for (index, pet) in Globals.pets.prefix(4).enumerated() {
           if let image = UIImage(named: pet.imageName) {
               let imageView = UIImageView(image: image)
               imageView.contentMode = .scaleAspectFit
               imageView.translatesAutoresizingMaskIntoConstraints = false
               
               let nameLabel = UILabel()
               nameLabel.text = pet.name
               nameLabel.textAlignment = .center
               nameLabel.translatesAutoresizingMaskIntoConstraints = false
               
               let container = UIView()
               container.translatesAutoresizingMaskIntoConstraints = false
               
               container.addSubview(imageView)
               container.addSubview(nameLabel)
               
               switch index {
               case 0:
                   topLeftPanel.addSubview(container)
                   addConstraintsForPanel(imageView, panel: topLeftPanel)
               case 1:
                   topRightPanel.addSubview(container)
                   addConstraintsForPanel(imageView, panel: topRightPanel)
               case 2:
                   bottomLeftPanel.addSubview(container)
                   addConstraintsForPanel(imageView, panel: bottomLeftPanel)
               case 3:
                   bottomRightPanel.addSubview(container)
                   addConstraintsForPanel(imageView, panel: bottomRightPanel)
               default:
                   break
               }
               
               NSLayoutConstraint.activate([
                   imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                   imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                   imageView.topAnchor.constraint(equalTo: container.topAnchor),
                   nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                   nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                   nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
                   nameLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor)
               ])
           }
       }
    }
    
    private func setupCollectionPanels() {
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        let spacing: CGFloat = 30 // spacing for bottom collection panel scroll
            
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: spacing),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -spacing),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -spacing),
            scrollView.heightAnchor.constraint(equalToConstant: 200) // Adjust as needed
        ])
        
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        
        NSLayoutConstraint.activate([
           stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: spacing),
           stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -spacing),
           stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: spacing),
           stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -spacing),
           stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, constant: -2 * spacing)
       ])
        
        for pet in Globals.pets {
            if let image = UIImage(named: pet.imageName) {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                imageView.translatesAutoresizingMaskIntoConstraints = false
                
                let nameLabel = UILabel()
                nameLabel.text = pet.name
                nameLabel.textAlignment = .center
                nameLabel.translatesAutoresizingMaskIntoConstraints = false
                
                let container = UIView()
                container.translatesAutoresizingMaskIntoConstraints = false
                
                container.addSubview(imageView)
                container.addSubview(nameLabel)
                container.backgroundColor = .lightGray;
                
                stackView.addArrangedSubview(container)
                
                // Set constraints to make the container a square
                NSLayoutConstraint.activate([
                    container.widthAnchor.constraint(equalTo: container.heightAnchor),
                    container.heightAnchor.constraint(equalTo: stackView.heightAnchor),
                    
                    imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                    imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                    imageView.topAnchor.constraint(equalTo: container.topAnchor),
                    imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -8),
                    
                    nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                    nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                    nameLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor)
                ])
            }
        }
        
        // Add tap gesture recognizers to each panel
        for (index, pet) in Globals.pets.enumerated() {
            let container = createPanelView(for: pet)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(panelTapped(_:)))
            container.addGestureRecognizer(tapGesture)
            container.tag = index
            stackView.addArrangedSubview(container)
        }
    }
    
    // Fit image in pet panels
    private func addConstraintsForPanel(_ imageView: UIImageView, panel: UIView) {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: panel.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: panel.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: panel.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: panel.bottomAnchor)
        ])
    }
    
    @objc private func panelTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedPanel = sender.view else { return }
                
        if let selectedPanel = selectedPanel {
            // Reset background color of previously selected panel
            selectedPanel.backgroundColor = .clear
        }
        
        // Set the background color of the tapped panel to indicate selection
        tappedPanel.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5)
        
        // Update the selected panel
        selectedPanel = tappedPanel
    
        guard let index = sender.view?.tag else { return }
        
        let tappedPet = Globals.pets[index]
        if let selectedPet = selectedPet, selectedPet.name == tappedPet.name {
            // If the same pet is tapped again, do nothing
            return
        }
        
        // Set the selected pet
        selectedPet = tappedPet
        
        // Update UI to reflect selection
        updateUI()
    }
        
        private func updateUI() {
            // Implement the update UI logic here
        }
        
        private func createPanelView(for pet: Pet) -> UIView {
            // Create and configure panel view for the pet
            let panelView = UIView()
            // Add image view, label, etc., and layout them within the panel view
            return panelView
        }
    
    @objc private func mainMenuButtonTapped() {
        mainMenuButtonTappedHandler?()
    }
    
    func updateButtonTitles() {
        // Update active pet buttons
        for (index, pet) in Globals.pets.enumerated() {
            if let button = viewWithTag(1000 + index) as? UIButton {
                button.setTitle(pet.name, for: .normal)
                
                button.removeFromSuperview()
                addSubview(button)
            }
        }
        
        // Update collection pet buttons
        for (index, pet) in Globals.pets.enumerated() {
            if let button = viewWithTag(2000 + index) as? UIButton {
                button.setTitle(pet.name, for: .normal)
                addSubview(button)
            }
        }
    }

}
