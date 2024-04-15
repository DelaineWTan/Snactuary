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
    let statsUIView = StatsUIView()
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
        // Initialize user data if unsynced
        Utilities.initUserData()
        
        
        addSubview(mainMenuUIView)
        // Initially the other UI views
        addSubview(petSelectionUIView)
        petSelectionUIView.isHidden = true
        addSubview(pauseMenuUIView)
        pauseMenuUIView.isHidden = true
        addSubview(statsUIView)
        statsUIView.isHidden = true
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
        
        // Layout constraints for stats view
        statsUIView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statsUIView.centerXAnchor.constraint(equalTo: centerXAnchor),
            statsUIView.centerYAnchor.constraint(equalTo: centerYAnchor),
            statsUIView.widthAnchor.constraint(equalTo: widthAnchor),
            statsUIView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
        setupStatsMenuHandlers()
        
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
            Utilities.changeGameState(gameState: "inGame")
        }
        
        mainMenuUIView.selectPetsButtonTappedHandler = { [weak self] in
            // Hide main menu and show pet selection menu
            self?.mainMenuUIView.isHidden = true
            self?.petSelectionUIView.isHidden = false
            self?.petSelectionUIView.setupActivePanels()
            self?.petSelectionUIView.setupCollectionPanels()
            self?.petSelectionUIView.setupTopCenterLabel()
        }
        
        mainMenuUIView.statsButtonTappedHandler = { [weak self] in
            // Hide main menu and show stat menu
            self?.mainMenuUIView.isHidden = true
            self?.statsUIView.isHidden = false
            self?.statsUIView.updateStatistics()
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
    
    private func setupStatsMenuHandlers() {
        statsUIView.mainMenuButtonTappedHandler = { [weak self] in
            // Hide stats menu and show main menu
            self?.mainMenuUIView.isHidden = false
            self?.statsUIView.isHidden = true
        }
    }
    
    private func setupPauseMenuHandlers() {
        pauseMenuUIView.resumeButtonTappedHandler = { [weak self] in
            // Hide in pause menu and show game ui
            self?.pauseMenuUIView.isHidden = true
            self?.inGameUIView.isHidden = false
            Utilities.changeGameState(gameState: "inGame")
        }
        
        pauseMenuUIView.mainMenuButtonTappedHandler = { [weak self] in
            // Hide pause menu and show main menu
            self?.pauseMenuUIView.isHidden = true
            self?.mainMenuUIView.isHidden = false
            Utilities.changeGameState(gameState: "mainMenu")
        }
    }
    
    private func setupInGameUIHandlers() {
        inGameUIView.pauseButtonTappedHandler = { [weak self] in
            // Hide in game ui and show pause menu
            self?.pauseMenuUIView.isHidden = false
            self?.inGameUIView.isHidden = true
            Utilities.changeGameState(gameState: "paused")
        }
        
        inGameUIView.nextStageButtonTappedHandler = { [weak self] in
            
            // do cutscene here
            self?.inGameUIView.nextStageButton.isHidden = true
            self?.inGameUIView.stageClearLabel.isHidden = false
            
            // delete all food, stop recognizers, and handlers
            LifecycleManager.Instance.deleteAllFood()
            self?.enableAllGestures(isEnabled: false)
            self?.inGameUIView.pauseButton.isHidden = true
            
            let delayInSeconds = 12.0 // Adjust the delay time as needed
            // levitate pets in active party & play heavenly sfx
            Utilities.levitatePets(duration: delayInSeconds)
            SoundManager.Instance.playStageTransitionSFX()
            
            // Add a delay before performing additional logic
            DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
                // Perform additional logic after the delay
                // This closure will be executed after the specified delay
                
                // reset current hungerScore on stage & hungerMeter
                self?.inGameUIView.resetHunger()
                
                // increase food health
                var stageCount = UserDefaults.standard.integer(forKey: Globals.stageCountKey)
                
                // Increment stage count and play new bgm
                SoundManager.Instance.stopCurrentBGM()
                stageCount += 1
                Globals.stagesPassed += 1
                self?.inGameUIView.setStageCount(stageCount: stageCount)
                UserDefaults.standard.set(stageCount, forKey: Globals.stageCountKey)
                SoundManager.Instance.playCurrentStageBGM()
                // change stage visual aesthetics
                let stageNode = Globals.mainScene.rootNode.childNode(withName: "stagePlane", recursively: true)
                if let stageMat = stageNode?.geometry?.firstMaterial {
                    stageMat.diffuse.contents = StageAestheticsHelper.iterateStageVariation(stageMat)
                }
                
                // increase max HungerScore required to progress to next stage
                self?.inGameUIView.increaseMaxHungerScore()
                
                // save stage's food health multiplier
                UserDefaults.standard.set(Globals.foodHealthMultiplier, forKey: Globals.foodHealthMultiplierKey)
                
                UserDefaults.standard.synchronize()
                self?.inGameUIView.stageClearLabel.isHidden = true
                self?.enableAllGestures(isEnabled: true)
                self?.inGameUIView.pauseButton.isHidden = false
                Globals.playerNode.position.y = 0
            }
            
        }
    }
    
    // Implement the delegate method
    func swapSceneNode(with petModel: Pet, position: Int) {
        print(petModel.modelName)
        // load current Pet Model and ability
        let petNode = SCNNode()
        if let petModelScene = SCNScene(named: petModel.modelName) { // Find pet scene from assets file
            // Iterate and add all objects to form the pet node
            for childNode in petModelScene.rootNode.childNodes {
                petNode.addChildNode(childNode)
            }
        } else {
            print("Failed to load pet scene from file.")
        }
        
        // Replace current pet at position with new pet node and ability
        var oldPetNode = SCNNode()
        var oldAbilityNode = SCNNode()
        if let sceneNode = delegate?.getSceneNode() {
            if let mainPlayerNode = sceneNode.childNode(withName: "mainPlayer", recursively: true) {
                switch position {
                case 0:
                    oldPetNode = mainPlayerNode.childNode(withName: Globals.petModelNodeName[0], recursively: true)!
                    oldAbilityNode = mainPlayerNode.childNode(withName: Globals.petAbilityNodeName[0], recursively: true)!
                    break;
                case 1:
                    oldPetNode = mainPlayerNode.childNode(withName: Globals.petModelNodeName[1], recursively: true)!
                    oldAbilityNode = mainPlayerNode.childNode(withName: Globals.petAbilityNodeName[1], recursively: true)!
                    break;
                    
                case 2:
                    oldPetNode = mainPlayerNode.childNode(withName: Globals.petModelNodeName[2], recursively: true)!
                    oldAbilityNode = mainPlayerNode.childNode(withName: Globals.petAbilityNodeName[2], recursively: true)!
                    break;
                    
                case 3:
                    oldPetNode = mainPlayerNode.childNode(withName: Globals.petModelNodeName[3], recursively: true)!
                    oldAbilityNode = mainPlayerNode.childNode(withName: Globals.petAbilityNodeName[3], recursively: true)!
                    break;
                    
                default:
                    print("Position is not in the range 0-3")
                }
//                if (petModel.attackPattern == oldAbilityNode) {
//                    return // Don't swap if the abilities are the same
//                }
                petNode.position = oldPetNode.position
                petNode.orientation = oldPetNode.orientation
                petNode.scale = oldPetNode.scale
                petNode.name = oldPetNode.name // TODO: change node names to like pet1 instead of Cat.001 reference when initializing
                
                mainPlayerNode.addChildNode(petNode) // add new pet model node
                oldPetNode.removeFromParentNode()
                
                
                oldAbilityNode.removeFromParentNode()
                
                let ability = petModel.baseAbility.copy() as! Ability // add new pet ability node, create a duplicate of the reference
                _ = ability.activate()
                ability.name = oldAbilityNode.name
                mainPlayerNode.addChildNode(ability)
            }
        } else {
            print("Failed to load the scene.")
        }
    }
    
    private func enableAllGestures(isEnabled: Bool) {
        var responder: UIResponder? = self.next
        
        // Traverse up the responder chain until finding the GameViewController
        while responder != nil {
            if let viewController = responder as? GameViewController {
                // Disable all gesture recognizers associated with the GameViewController
                viewController.view.gestureRecognizers?.forEach { gestureRecognizer in
                    gestureRecognizer.isEnabled = isEnabled
                }
                break
            }
            responder = responder?.next
        }
    }
}
