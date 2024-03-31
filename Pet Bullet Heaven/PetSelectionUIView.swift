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
    let topLeftPanel = UIView()
    let topRightPanel = UIView()
    let bottomLeftPanel = UIView()
    let bottomRightPanel = UIView()
    // collection pet panels
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mainMenuButton)
        setupUI() // rerun everytime pets are sweapped
        setupCollectionPanels()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubview(mainMenuButton)
        setupUI()
        setupCollectionPanels()
    }
    
    private func setupUI() {
        // Clear existing views from stackView
        topLeftPanel.subviews.forEach { $0.removeFromSuperview() }
        topRightPanel.subviews.forEach { $0.removeFromSuperview() }
        bottomLeftPanel.subviews.forEach { $0.removeFromSuperview() }
        bottomRightPanel.subviews.forEach { $0.removeFromSuperview() }
        
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
        for (index, pet) in Globals.activePets.enumerated() {
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
               
               // add the tap gesture
               let tapGesture = UITapGestureRecognizer(target: self, action: #selector(activePanelTapped(_:)))
               container.addGestureRecognizer(tapGesture)
               
               container.tag = index
               
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
        
        for (index,pet) in Globals.pets.enumerated() {
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
            setupUI()
            
            print("active Panel Tag: \(activePanelTag)")
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
            setupUI()
            
            // delegate to swap 3D models
            print("active Panel Tag: \(activePanelTag)")
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
            setupUI()

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
