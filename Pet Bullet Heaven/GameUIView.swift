//
//  GameUIView.swift
//  Pet Bullet Heaven
//
//  Created by Delaine on 2024-02-08.
//  This is the UI that overlays the game scene.
//
import UIKit
import SceneKit

class GameUIView: UIView, PetSelectionDelegate {
    let mainMenuUIView = MainMenuUIView()
    let petSelectionUIView = PetSelectionUIView()
    let pauseMenuUIView = PauseMenuUIView()
    let inGameUIView = InGameUIView()
    weak var delegate: SceneProvider?
    
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
        petSelectionUIView.delegate = self
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
    
    // Implement the delegate method
    func swapSceneNode(with petModel: Pet, position: Int) {
        print(petModel.modelName)
        // load current Pet Model
        let petNode = SCNNode()
        if let petModelScene = SCNScene(named: petModel.modelName) {
            // Iterate through all child nodes in the loaded scene and add them to the scene node
            for childNode in petModelScene.rootNode.childNodes {
                petNode.addChildNode(childNode)
            }
        } else {
            print("Failed to load pet scene from file.")
        }
        
        // Replace current pet at position with new pet node
        var node = SCNNode()
        if let sceneNode = delegate?.getSceneNode() {
            if let mainPlayerNode = sceneNode.childNode(withName: "mainPlayer", recursively: true) {
                switch position {
                case 0:
                    node = mainPlayerNode.childNode(withName: "Frog.001 reference", recursively: true)!
                    break;
                case 1:
                    node = mainPlayerNode.childNode(withName: "Penguin.001 reference", recursively: true)!
                    break;

                case 2:
                    node = mainPlayerNode.childNode(withName: "Cat.001 reference", recursively: true)!
                    break;

                case 3:
                    node = mainPlayerNode.childNode(withName: "Duck.001 reference", recursively: true)!
                    break;

                default:
                    print("Position is not in the range 0-3")
                }
                mainPlayerNode.addChildNode(petNode)
                petNode.position = node.position
                petNode.orientation = node.orientation
                petNode.scale = node.scale
                petNode.name = node.name // TODO: change node names to like pet1 instead of Cat.001 reference when initializing
                node.removeFromParentNode()
            }
        } else {
            print("Failed to load the scene.")
        }
    }
}
