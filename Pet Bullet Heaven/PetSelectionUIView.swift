//  PetSelectionUIView.swift
//  Pet Bullet Heaven
//
//  Created by Delaine on 2024-02-08.
//
import UIKit
import SwiftUI
import Combine
import SceneKit

protocol PetSelectionDelegate: AnyObject {
    func swapSceneNode(with petModel: Pet, position: Int)
}

class PetSelectionUIView: UIView {
    weak var delegate: PetSelectionDelegate?
    var selectedCollectionPanel: UIView?
    var selectedActivePanel: UIView?
    var selectedPet: Pet?
    private var activePanelTag: Int? = nil
    private var collectionPanelTag: Int? = nil
    
    var mainMenuButtonTappedHandler: (() -> Void)?
    
    lazy var mainMenuButton: UIButton = {
        let button = Utilities.makeButton(title: "Main Menu", image: UIImage(named: "cloud_pink.png"), backgroundColor: .blue, target: self, action: #selector(mainMenuButtonTapped))
        return button
    }()

    // active pet panels
    let activePetView = UIStackView()
    // collection pet panels
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    // total pet view label
    let totalPetLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionPanels()
        setupActivePanels()
        addSubview(mainMenuButton)
        mainMenuButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainMenuButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16), // Adjust the top anchor as needed
            mainMenuButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16), // Adjust the leading anchor as needed
            mainMenuButton.widthAnchor.constraint(equalToConstant: 100), // Adjust the width as needed
            mainMenuButton.heightAnchor.constraint(equalToConstant: 70) // Adjust the height as needed
        ])
        setupTopCenterLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubview(mainMenuButton)
        setupCollectionPanels()
        setupActivePanels()
        addSubview(mainMenuButton)
        mainMenuButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainMenuButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            mainMenuButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            mainMenuButton.widthAnchor.constraint(equalToConstant: 147),
            mainMenuButton.heightAnchor.constraint(equalToConstant: 98)
        ])
        setupTopCenterLabel()
    }
    
    public func setupTopCenterLabel() {
    totalPetLabel.subviews.forEach { $0.removeFromSuperview() }
        
        var totalPow: Int = 0
        var totalSpeed: Int = 0
        for petIndex in 0...Globals.activePets.count - 1  {
            let pet = Globals.pets[Globals.activePets[petIndex]]
            totalPow += Int(pet!.baseAttack)
            totalSpeed += Int(pet!.speed)
        }
        
        totalPetLabel.backgroundColor = Globals.petSelectionUIColors.selectedHalf
        totalPetLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(totalPetLabel)
        
        let topCenterLabel = UILabel()
        topCenterLabel.text = "Pet Team Selection"
        topCenterLabel.textColor = .white
        topCenterLabel.textAlignment = .center
        topCenterLabel.adjustsFontSizeToFitWidth = true // Enable auto-shrinking
        topCenterLabel.minimumScaleFactor = 0.5 // Set the minimum scale factor for auto-shrinking
        topCenterLabel.translatesAutoresizingMaskIntoConstraints = false
        totalPetLabel.addSubview(topCenterLabel)
        
        let firstCenteredLabel = UILabel()
        firstCenteredLabel.text = "Team Purr-ower: \(totalPow)"
        firstCenteredLabel.textColor = .white
        firstCenteredLabel.textAlignment = .center
        firstCenteredLabel.adjustsFontSizeToFitWidth = true // Enable auto-shrinking
        firstCenteredLabel.minimumScaleFactor = 0.5 // Set the minimum scale factor for auto-shrinking
        firstCenteredLabel.translatesAutoresizingMaskIntoConstraints = false
        totalPetLabel.addSubview(firstCenteredLabel)
        
        let secondCenteredLabel = UILabel()
        secondCenteredLabel.text = "Team Muwuvement Sweed: \(totalSpeed)"
        secondCenteredLabel.textColor = .white
        secondCenteredLabel.textAlignment = .center
        secondCenteredLabel.adjustsFontSizeToFitWidth = true // Enable auto-shrinking
        secondCenteredLabel.minimumScaleFactor = 0.5 // Set the minimum scale factor for auto-shrinking
        secondCenteredLabel.translatesAutoresizingMaskIntoConstraints = false
        totalPetLabel.addSubview(secondCenteredLabel)
        
        NSLayoutConstraint.activate([
            totalPetLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16), // Adjust the top anchor as needed
            totalPetLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 50), // Center horizontally
            topCenterLabel.topAnchor.constraint(equalTo: totalPetLabel.topAnchor, constant: 8), // Adjust the top anchor as needed
            topCenterLabel.leadingAnchor.constraint(equalTo: totalPetLabel.leadingAnchor, constant: 8), // Adjust the leading anchor as needed
            topCenterLabel.trailingAnchor.constraint(equalTo: totalPetLabel.trailingAnchor, constant: -8), // Adjust the trailing anchor as needed
            firstCenteredLabel.topAnchor.constraint(equalTo: topCenterLabel.bottomAnchor, constant: 8), // Adjust the top anchor as needed
            firstCenteredLabel.leadingAnchor.constraint(equalTo: totalPetLabel.leadingAnchor, constant: 8), // Adjust the leading anchor as needed
            firstCenteredLabel.trailingAnchor.constraint(equalTo: totalPetLabel.trailingAnchor, constant: -8), // Adjust the trailing anchor as needed
            secondCenteredLabel.topAnchor.constraint(equalTo: firstCenteredLabel.bottomAnchor, constant: 8), // Adjust the top anchor as needed
            secondCenteredLabel.leadingAnchor.constraint(equalTo: totalPetLabel.leadingAnchor, constant: 8), // Adjust the leading anchor as needed
            secondCenteredLabel.trailingAnchor.constraint(equalTo: totalPetLabel.trailingAnchor, constant: -8), // Adjust the trailing anchor as needed
            totalPetLabel.bottomAnchor.constraint(equalTo: secondCenteredLabel.bottomAnchor, constant: 8) // Adjust the bottom anchor as needed
        ])
    }
    
    public func setupActivePanels() {
        // Clear existing views from stackView
        activePetView.subviews.forEach { $0.removeFromSuperview() }
        
        addSubview(activePetView)
        activePetView.translatesAutoresizingMaskIntoConstraints = false

        let panelSpacing: CGFloat = 10// panel in between space
        let panelSize: CGFloat = 85 // Calculate panel size with 3 spacings for 4 panels
            
        NSLayoutConstraint.activate([
            activePetView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: panelSpacing),
            activePetView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -panelSpacing),
            activePetView.heightAnchor.constraint(equalToConstant: panelSize * 1.25),
            activePetView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activePetView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 160) // spacing between panel and screen bottom
        ])
        activePetView.backgroundColor = Globals.petSelectionUIColors.selectedHalf
        activePetView.spacing = panelSpacing
        activePetView.distribution = .fillEqually
        
        // Add label to the top left corner of activePetView
        let label = UILabel()
        label.text = "Active Pets"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        activePetView.addSubview(label)
        label.backgroundColor = Globals.petSelectionUIColors.selectedHalf
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: activePetView.leadingAnchor),
            label.topAnchor.constraint(equalTo: activePetView.topAnchor, constant: -20)
        ])
        
        for petIndex in 0...Globals.activePets.count - 1 {
            let pet = Globals.pets[Globals.activePets[petIndex]]!
            if let image = UIImage(named: pet.imageName) {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                imageView.translatesAutoresizingMaskIntoConstraints = false
                
                let nameLabel = UILabel()
                nameLabel.text = pet.name
                nameLabel.textColor = .white
                nameLabel.textAlignment = .center
                nameLabel.adjustsFontSizeToFitWidth = true
                nameLabel.minimumScaleFactor = 0.5
                nameLabel.translatesAutoresizingMaskIntoConstraints = false
                
                let descriptionLabel = UILabel()
                descriptionLabel.text = "ATK \(Int(pet.baseAttack)), SPD \(Int(pet.speed))"
                descriptionLabel.textAlignment = .center
                descriptionLabel.textColor = .white
                descriptionLabel.font = UIFont.systemFont(ofSize: 12) // Adjust font and size as needed
                descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

                let additionalTextLabel = UILabel()
                additionalTextLabel.text = "LVL \(Int(pet.petLevel))"
                additionalTextLabel.textColor = .white
                additionalTextLabel.textAlignment = .left
                additionalTextLabel.font = UIFont.systemFont(ofSize: 12) // Adjust font and size as needed
                additionalTextLabel.translatesAutoresizingMaskIntoConstraints = false

               let container = UIView()
                container.translatesAutoresizingMaskIntoConstraints = false
                
                container.addSubview(imageView)
                container.addSubview(nameLabel)
                container.addSubview(descriptionLabel)
                container.addSubview(additionalTextLabel)
                container.backgroundColor = Globals.petSelectionUIColors.neutralHalf;
                
                activePetView.addArrangedSubview(container)
                
                // Set constraints for imageView
                NSLayoutConstraint.activate([
                    imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                    imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                    imageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 15),
                    imageView.heightAnchor.constraint(equalToConstant: 0.6 * panelSize),// Adjust height as needed
                    
                    // Description label constraints
                    descriptionLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor), // Adjust left spacing as needed
                    descriptionLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                    descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor), // Adjust spacing between name and description
                    descriptionLabel.heightAnchor.constraint(equalToConstant: 10), // Adjust height as needed
                    
                    // Set constraints for nameLabel
                    nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                    nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                    nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor), // Adjust spacing between imageView and nameLabel
                    
                    // Set constraints for level label
                    additionalTextLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                    additionalTextLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                    additionalTextLabel.topAnchor.constraint(equalTo: container.topAnchor), // Adjust spacing between imageView and nameLabel
                    additionalTextLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor),
                ])
                
                // Add tap gesture recognizer to the container view
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(activePanelTapped(_:)))
                container.addGestureRecognizer(tapGesture)
                container.tag = petIndex
            }
        }
    }
    
    public func setupCollectionPanels() {
        // Clear existing views from stackView
        stackView.subviews.forEach { $0.removeFromSuperview() }
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let spacing: CGFloat = 30 // spacing for bottom collection panel scroll
        let panelSize: CGFloat = 75 // Calculate panel size with 3 spacings for 4 panels
         
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        scrollView.backgroundColor = Globals.petSelectionUIColors.neutralHalf
        scrollView.addSubview(stackView)
        scrollView.showsHorizontalScrollIndicator = false
        
        NSLayoutConstraint.activate([
           stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
           stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
           stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
           stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
           //stackView.heightAnchor.constraint(equalToConstant: panelSize),
           scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: spacing),
           scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -spacing),
           scrollView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
           scrollView.heightAnchor.constraint(equalToConstant: panelSize * 1.25)
       ])
        
//        // Add label to the top left corner of activePetView
//        let collabel = UILabel()
//        collabel.text = "All Pets"
//        collabel.textColor = .white
//        collabel.translatesAutoresizingMaskIntoConstraints = false
//        stackView.addSubview(collabel)
//        collabel.backgroundColor = Globals.petSelectionUIColors.neutralHalf
//
//        NSLayoutConstraint.activate([
//            collabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: spacing),
//            collabel.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 0)
//        ])
        
        for pet in Globals.pets.values {
            if let image = UIImage(named: pet.imageName) {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                imageView.translatesAutoresizingMaskIntoConstraints = false
                
                let nameLabel = UILabel()
                nameLabel.text = pet.name
                nameLabel.textAlignment = .center
                nameLabel.adjustsFontSizeToFitWidth = true
                nameLabel.minimumScaleFactor = 0.5
                nameLabel.translatesAutoresizingMaskIntoConstraints = false
                nameLabel.font = UIFont.systemFont(ofSize: 14) // Adjust font and size as needed

                let descriptionLabel = UILabel()
                descriptionLabel.text = "ATK \(Int(pet.baseAttack)), SPD \(Int(pet.speed))"
                descriptionLabel.textAlignment = .center
                descriptionLabel.font = UIFont.systemFont(ofSize: 10) // Adjust font and size as needed
                descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

                let additionalTextLabel = UILabel()
                additionalTextLabel.text = "LVL \(Int(pet.petLevel))"
                additionalTextLabel.textAlignment = .left
                additionalTextLabel.font = UIFont.systemFont(ofSize: 10) // Adjust font and size as needed
                additionalTextLabel.translatesAutoresizingMaskIntoConstraints = false

               let container = UIView()
                container.translatesAutoresizingMaskIntoConstraints = false
                
                container.addSubview(imageView)
                container.addSubview(nameLabel)
                container.addSubview(descriptionLabel)
                container.addSubview(additionalTextLabel)
                if (pet.unlocked) {
                    container.backgroundColor = Globals.petSelectionUIColors.neutralHalf;
                } else {
                    container.backgroundColor = Globals.petSelectionUIColors.locked;

                }
                
                stackView.addArrangedSubview(container)
                
                // Set constraints for imageView
                NSLayoutConstraint.activate([
                    imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                    imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                    imageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 15),
                    imageView.heightAnchor.constraint(equalToConstant: 0.6 * panelSize),// Adjust height as needed
                    
                    // Description label constraints
                    descriptionLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor), // Adjust left spacing as needed
                    descriptionLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                    descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor), // Adjust spacing between name and description
                    descriptionLabel.heightAnchor.constraint(equalToConstant: 10), // Adjust height as needed
                    
                    // Set constraints for nameLabel                    
                    nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                    nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                    nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor), // Adjust spacing between imageView and nameLabel
                    
                    // Set constraints for level label
                    additionalTextLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                    additionalTextLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                    additionalTextLabel.topAnchor.constraint(equalTo: container.topAnchor), // Adjust spacing between imageView and nameLabel
                    additionalTextLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor),
                    
                    // Set width and height constraint for container
                    container.widthAnchor.constraint(equalToConstant: panelSize),
                    container.heightAnchor.constraint(equalToConstant: panelSize * 1.25)
                ])
                
                // Add tap gesture recognizer to the container view
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(collectionPanelTapped(_:)))
                container.addGestureRecognizer(tapGesture)
                container.tag = pet.id
            }
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
    
    @objc private func collectionPanelTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view else {
            return
        }
        
        // Store the original color
        let originalColor = sender.view?.backgroundColor

        let selectedPet = Globals.pets[tappedView.tag]!
        // exit if selecting duplicate or locked
        if (Globals.activePets.contains(selectedPet.id) || (!Globals.pets[Int(tappedView.tag)]!.unlocked)) {
            // Animate the color change
            UIView.animate(withDuration: 0.25, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                // Change the button's background color to the highlight color
                sender.view?.backgroundColor = Globals.petSelectionUIColors.error
            }) { (_) in
                // After the animation completes, restore the original color after a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    UIView.animate(withDuration: 0.25) {
                        // Restore the original color
                        sender.view?.backgroundColor = originalColor
                    }
                }
            }
            return
        }
        // Update the collection panel tag
        collectionPanelTag = tappedView.tag
        
        // Animate the background color change
        UIView.animate(withDuration: 0.5, animations: {
            tappedView.backgroundColor = Globals.petSelectionUIColors.selected
        })
        
        // If an active and collection panel selected
        if let activePanelTag = activePanelTag, let collectionPanelTag = collectionPanelTag {
            // Swap the pets between active and collection panels
            let collectionPet = Globals.pets[collectionPanelTag]!
            Globals.activePets[Int(activePanelTag)] = collectionPet.id

            // Update the view
            setupActivePanels()
            setupTopCenterLabel()
            
            // delegate to swap 3D models
            Utilities.swapSceneNode(with: collectionPet, position: activePanelTag)

            // Deselect both buttons
            self.activePanelTag = nil
            self.collectionPanelTag = nil
            // Reset collection panel color
            if let tappedPanel = sender.view {
                tappedPanel.backgroundColor = Globals.petSelectionUIColors.neutralHalf
            }
        } else { // no collection panels selected
            // Toggle highlighting for collection panel
            if let tappedPanel = sender.view {
                if let selectedCollectionPanel = selectedCollectionPanel {
                    // Reset background color of previously selected panel
                    selectedCollectionPanel.backgroundColor = Globals.petSelectionUIColors.neutralHalf
                }
                // Set the background color of the tapped panel to indicate selection
                tappedPanel.backgroundColor = Globals.petSelectionUIColors.selectedHalf
                // Update the selected panel
                selectedCollectionPanel = tappedPanel
            }
        }
    }
    @objc private func activePanelTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view else {
            return
        }
        
        // Update the collection panel tag
        activePanelTag = tappedView.tag
        
        // Animate the background color change
        UIView.animate(withDuration: 0.5, animations: {
            tappedView.backgroundColor = Globals.petSelectionUIColors.selected
        })
        
        // If an active and collection panel selected
        if let activePanelTag = activePanelTag, let collectionPanelTag = collectionPanelTag {
            // Swap the pets between active and collection panels
            let collectionPet = Globals.pets[collectionPanelTag]!
            Globals.activePets[Int(activePanelTag)] = collectionPet.id

            // Update the view
            setupActivePanels()
            setupTopCenterLabel()
            
            // delegate to swap 3D models
            Utilities.swapSceneNode(with: collectionPet, position: activePanelTag)

            // Deselect both buttons
            self.activePanelTag = nil
            self.collectionPanelTag = nil
            // Reset collection panel color
            if let selectedCollectionPanel = selectedCollectionPanel {
                // Reset background color of previously selected panel
                selectedCollectionPanel.backgroundColor = Globals.petSelectionUIColors.neutralHalf
            }
        } else { // no collection panels selected
            // Toggle highlighting for collection panel
            if let tappedPanel = sender.view {
                if let selectedActivePanel = selectedActivePanel {
                    // Reset background color of previously selected panel
                    selectedActivePanel.backgroundColor = Globals.petSelectionUIColors.neutralHalf
                }
                // Set the background color of the tapped panel to indicate selection
                tappedPanel.backgroundColor = Globals.petSelectionUIColors.selectedHalf
            
                // Update the selected panel
                selectedActivePanel = tappedPanel
            }
        }
    }
    
    @objc private func mainMenuButtonTapped() {
        mainMenuButtonTappedHandler?()
    }
    
    func updateButtonTitles() {
        // Update active pet buttons
        for petIndex in 0...Globals.activePets.count - 1 {
            let pet = Globals.pets[Globals.activePets[petIndex]]!
            if let button = viewWithTag(1000 + petIndex) as? UIButton {
                button.setTitle(pet.name, for: .normal)
                
                button.removeFromSuperview()
                addSubview(button)
            }
        }
        
        // Update collection pet buttons
        for petIndex in 0...Globals.activePets.count - 1 {
            let pet = Globals.pets[Globals.activePets[petIndex]]!
            if let button = viewWithTag(2000 + petIndex) as? UIButton {
                button.setTitle(pet.name, for: .normal)
                addSubview(button)
            }
        }
    }

}
