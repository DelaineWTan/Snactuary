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
    let activePetView = UIStackView()
    // collection pet panels
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    
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
            mainMenuButton.heightAnchor.constraint(equalToConstant: 40) // Adjust the height as needed
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
            mainMenuButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16), // Adjust the top anchor as needed
            mainMenuButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16), // Adjust the leading anchor as needed
            mainMenuButton.widthAnchor.constraint(equalToConstant: 100), // Adjust the width as needed
            mainMenuButton.heightAnchor.constraint(equalToConstant: 40) // Adjust the height as needed
        ])
        setupTopCenterLabel()
    }
    
    private func setupTopCenterLabel() {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        let topCenterLabel = UILabel()
        topCenterLabel.text = "Pet Team Selection"
        topCenterLabel.textColor = .white
        topCenterLabel.textAlignment = .center
        topCenterLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(topCenterLabel)
        
        let firstCenteredLabel = UILabel()
        firstCenteredLabel.text = "Team Power: 40"
        firstCenteredLabel.textColor = .white
        firstCenteredLabel.textAlignment = .center
        firstCenteredLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(firstCenteredLabel)
        
        let secondCenteredLabel = UILabel()
        secondCenteredLabel.text = "Team Speed: 20"
        secondCenteredLabel.textColor = .white
        secondCenteredLabel.textAlignment = .center
        secondCenteredLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(secondCenteredLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16), // Adjust the top anchor as needed
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 40), // Center horizontally
            topCenterLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8), // Adjust the top anchor as needed
            topCenterLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8), // Adjust the leading anchor as needed
            topCenterLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8), // Adjust the trailing anchor as needed
            firstCenteredLabel.topAnchor.constraint(equalTo: topCenterLabel.bottomAnchor, constant: 8), // Adjust the top anchor as needed
            firstCenteredLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8), // Adjust the leading anchor as needed
            firstCenteredLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8), // Adjust the trailing anchor as needed
            secondCenteredLabel.topAnchor.constraint(equalTo: firstCenteredLabel.bottomAnchor, constant: 8), // Adjust the top anchor as needed
            secondCenteredLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8), // Adjust the leading anchor as needed
            secondCenteredLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8), // Adjust the trailing anchor as needed
            containerView.bottomAnchor.constraint(equalTo: secondCenteredLabel.bottomAnchor, constant: 8) // Adjust the bottom anchor as needed
        ])
    }
    
    private func setupActivePanels() {
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
            activePetView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 200) // spacing between panel and screen bottom
        ])
        activePetView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5)
        activePetView.spacing = panelSpacing
        
        // Add label to the top left corner of activePetView
        let label = UILabel()
        label.text = "Active Pets"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        activePetView.addSubview(label)
        label.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: activePetView.leadingAnchor),
            label.topAnchor.constraint(equalTo: activePetView.topAnchor, constant: -20)
        ])
        
        for (index,pet) in Globals.activePets.enumerated() {
            if let image = UIImage(named: pet.imageName) {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                imageView.translatesAutoresizingMaskIntoConstraints = false
                
                let nameLabel = UILabel()
                nameLabel.text = pet.name
                nameLabel.textColor = .white
                nameLabel.textAlignment = .center
                nameLabel.translatesAutoresizingMaskIntoConstraints = false
                
                let descriptionLabel = UILabel()
                descriptionLabel.text = "ATK 10, SPD 5"
                descriptionLabel.textAlignment = .center
                descriptionLabel.textColor = .white
                descriptionLabel.font = UIFont.systemFont(ofSize: 12) // Adjust font and size as needed
                descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

                let additionalTextLabel = UILabel()
                additionalTextLabel.text = "LVL 1"
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
                container.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5);
                
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
                
                // Set width and height constraint for container
                NSLayoutConstraint.activate([
                    container.widthAnchor.constraint(equalToConstant: panelSize),
                    container.heightAnchor.constraint(equalToConstant: panelSize)
                ])
                
                // Add tap gesture recognizer to the container view
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(activePanelTapped(_:)))
                container.addGestureRecognizer(tapGesture)
                container.tag = index
            }
        }
    }
    
    private func setupCollectionPanels() {
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        let spacing: CGFloat = 30 // spacing for bottom collection panel scroll
        let panelSize: CGFloat = 75 // Calculate panel size with 3 spacings for 4 panels
            
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: spacing),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -spacing),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60),
            scrollView.heightAnchor.constraint(equalToConstant: panelSize * 1.25) // Adjust as needed
        ])
        
        scrollView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        
        NSLayoutConstraint.activate([
           stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
           stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
           stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
           stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
           stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
       ])
        
//        // Add label to the top left corner of activePetView
//        let collabel = UILabel()
//        collabel.text = "All Pets"
//        collabel.textColor = .white
//        collabel.translatesAutoresizingMaskIntoConstraints = false
//        stackView.addSubview(collabel)
//        collabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
//        
//        NSLayoutConstraint.activate([
//            collabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: spacing),
//            collabel.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 0)
//        ])
        
        for (index,pet) in Globals.pets.enumerated() {
            if let image = UIImage(named: pet.imageName) {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                imageView.translatesAutoresizingMaskIntoConstraints = false
                
                let nameLabel = UILabel()
                nameLabel.text = pet.name
                nameLabel.textAlignment = .center
                nameLabel.translatesAutoresizingMaskIntoConstraints = false
                nameLabel.font = UIFont.systemFont(ofSize: 14) // Adjust font and size as needed

                let descriptionLabel = UILabel()
               descriptionLabel.text = "ATK 10, SPD 5"
                descriptionLabel.textAlignment = .center
               descriptionLabel.font = UIFont.systemFont(ofSize: 10) // Adjust font and size as needed
               descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

                let additionalTextLabel = UILabel()
               additionalTextLabel.text = "LVL 1"
                additionalTextLabel.textAlignment = .left
               additionalTextLabel.font = UIFont.systemFont(ofSize: 10) // Adjust font and size as needed
               additionalTextLabel.translatesAutoresizingMaskIntoConstraints = false

               let container = UIView()
                container.translatesAutoresizingMaskIntoConstraints = false
                
                container.addSubview(imageView)
                container.addSubview(nameLabel)
                container.addSubview(descriptionLabel)
                container.addSubview(additionalTextLabel)
                container.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5);
                
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
                ])
                
                // Set width and height constraint for container
                NSLayoutConstraint.activate([
                    container.widthAnchor.constraint(equalToConstant: panelSize),
                    container.heightAnchor.constraint(equalToConstant: panelSize * 1.5)
                ])
                
                // Add tap gesture recognizer to the container view
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(collectionPanelTapped(_:)))
                container.addGestureRecognizer(tapGesture)
                container.tag = index
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
        
        // Update the collection panel tag
        collectionPanelTag = tappedView.tag
        
        // If an active and collection panel selected
        if let activePanelTag = activePanelTag, let collectionPanelTag = collectionPanelTag {
            // Swap the pets between active and collection panels
            let collectionPet = Globals.pets[collectionPanelTag]
            Globals.activePets[activePanelTag] = collectionPet

            // Update the view
            setupActivePanels()
            
            // delegate to swap 3D models
            delegate?.swapSceneNode(with: collectionPet, position: activePanelTag)

            // Deselect both buttons
            self.activePanelTag = nil
            self.collectionPanelTag = nil
            // Reset collection panel color
            if let selectedCollectionPanel = selectedCollectionPanel {
                // Reset background color of previously selected panel
                selectedCollectionPanel.backgroundColor = .lightGray
            }
        } else { // no collection panels selected
            // Toggle highlighting for collection panel
            if let tappedPanel = sender.view {
                if let selectedCollectionPanel = selectedCollectionPanel {
                    // Reset background color of previously selected panel
                    selectedCollectionPanel.backgroundColor = .lightGray
                }
                // Set the background color of the tapped panel to indicate selection
                tappedPanel.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5)
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
        
        // If an active and collection panel selected
        //if  (collectionPanelSelected){
        if let activePanelTag = activePanelTag, let collectionPanelTag = collectionPanelTag {
            // Swap the pets between active and collection panels
            let collectionPet = Globals.pets[collectionPanelTag]
            Globals.activePets[activePanelTag] = collectionPet

            // Update the view
            setupActivePanels()
            
            // delegate to swap 3D models
            delegate?.swapSceneNode(with: collectionPet, position: activePanelTag)

            // Deselect both buttons
            self.activePanelTag = nil
            self.collectionPanelTag = nil
            // Reset collection panel color
            if let selectedCollectionPanel = selectedCollectionPanel {
                // Reset background color of previously selected panel
                selectedCollectionPanel.backgroundColor = .lightGray
            }
        } else { // no collection panels selected
            // Toggle highlighting for collection panel
            if let tappedPanel = sender.view {
                if let selectedActivePanel = selectedActivePanel {
                    // Reset background color of previously selected panel
                    selectedActivePanel.backgroundColor = .lightGray
                }
                // Set the background color of the tapped panel to indicate selection
                tappedPanel.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5)
                // Update the selected panel
                selectedActivePanel = tappedPanel
            }
        }
    }
    
    private func updateViewIfBothPanelsHighlighted() {
        // Check if both an active panel and a collection panel are highlighted
        if let _ = activePanelTag, let _ = collectionPanelTag {
            // Update Globals.activePets with Globals.pets
            Globals.activePets[activePanelTag!] = Globals.pets[collectionPanelTag!]
            
            // Update the view
            //setupUI()

            // Deselect both buttons
            activePanelTag = nil
            collectionPanelTag = nil
            
        }
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
