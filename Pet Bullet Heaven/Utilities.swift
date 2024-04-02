//
//  Utility.swift
//  Pet Bullet Heaven
//
//  Created by Jun Solomon on 2024-03-31.
//

import Foundation
import SceneKit
import UIKit

public class Utilities {
    // Implement the delegate method
    static func swapSceneNode(with petNode: Pet, position: Int) {

        if let petModelScene = SCNScene(named: petNode.modelName) { // Find pet scene from assets file
            // Iterate and add all objects to form the pet node
            for childNode in petModelScene.rootNode.childNodes {
                petNode.addChildNode(childNode)
            }
        } else {
            print("Failed to load pet scene from file.")
        }
        
        // Replace current pet at position with new pet node and ability
        var petSlotNode = SCNNode()
        var oldAbilityNode = SCNNode()
        if let mainPlayerNode = Globals.mainScene.rootNode.childNode(withName: "mainPlayer", recursively: true) {
            petSlotNode = mainPlayerNode.childNode(withName: "pos\(position)", recursively: true)!
            oldAbilityNode = mainPlayerNode.childNode(withName: Globals.petAbilityNodeName[position], recursively: true)!
            petSlotNode.enumerateChildNodes { (node, stop) in
                node.removeFromParentNode()
            }
            petSlotNode.addChildNode(petNode)
            
            oldAbilityNode.removeFromParentNode()
            
            let ability = petNode.attackPattern.copy() as! Ability // add new pet ability node, create a duplicate of the reference
            _ = ability.ActivateAbility()
            
            ability.name = Globals.petAbilityNodeName[position]
            mainPlayerNode.addChildNode(ability)
            
        } else {
            print("Failed to load the scene.")
        }
    }
    // Create a UI button with a standardized appearance
    public static func makeButton(title: String, image: UIImage?, backgroundColor: UIColor, target: Any?, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        if let image = image {
            button.setBackgroundImage(image, for: .normal)
        } else
        {
            button.backgroundColor = backgroundColor
        }
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        button.tintColor = .white
        // Set text shadow for the titleLabel
        button.titleLabel?.shadowColor = UIColor.black
        button.titleLabel?.shadowOffset = CGSize(width: 1.0, height: 1.0)
        // Allow multiple lines
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.layer.cornerRadius = 8
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }
    
    /// Resets persistent user data
    public static func initUserData() {
        let currentUserDataVersion = UserDefaults.standard.integer(forKey: Globals.userDataVersionKey)
        let latestUserDataVersion = Globals.userDataVersion
        if (currentUserDataVersion != latestUserDataVersion) {
            print("User data version out of date (v\(currentUserDataVersion)), initializing to v\(latestUserDataVersion)...")
            UserDefaults.standard.set(0, forKey: Globals.totalScoreKey)
            UserDefaults.standard.set(0, forKey: Globals.stageScoreKey)
            UserDefaults.standard.set(Globals.defaultStageCount, forKey: Globals.stageCountKey)
            UserDefaults.standard.set(Globals.defaultMaxHungerScore, forKey: Globals.stageMaxScorekey)
            UserDefaults.standard.set(Globals.foodHealthMultiplierKey, forKey: Globals.foodHealthMultiplierKey)
        }
    }
    
    /// Prints all user data to console
    public static func printAllUserData() {
        print("total score: \(UserDefaults.standard.integer(forKey: Globals.totalScoreKey))")
        print("stage score: \(UserDefaults.standard.integer(forKey: Globals.stageScoreKey))")
        //print("stage label score: \(overlayView.inGameUIView.getHungerScore)")
        print("stage count: \(UserDefaults.standard.integer(forKey: Globals.stageCountKey))")
        print("stage max score: \(UserDefaults.standard.integer(forKey: Globals.stageMaxScorekey))")
        print("food health multiplier: \(UserDefaults.standard.integer(forKey: Globals.foodHealthMultiplierKey))")
        
        print("\n")
    }
    
    public static func changeGameState(gameState: String) {
        
        switch gameState {
        case "paused":
            Globals.timeScale = 0
            Globals.inMainMenu = false
            // something
        case "mainMenu":
            Globals.timeScale = 0
            Globals.inMainMenu = true
            LifecycleManager.Instance.deleteAllFood()
            // something
        case "inGame":
            Globals.timeScale = 1
            Globals.inMainMenu = false
        default:
            Globals.timeScale = 1
            // something
        }
    }
}

extension Comparable {
    func clamp(min: Self, max: Self) -> Self {
        return Swift.max(min, Swift.min(self, max))
    }
}
