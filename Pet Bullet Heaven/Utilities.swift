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
        print(petNode.modelName)
        // load current Pet Model and ability

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
            //petNode.name = petModel.modelName
            
            oldAbilityNode.removeFromParentNode()
            
            let ability = petNode.attackPattern.copy() as! Ability // add new pet ability node, create a duplicate of the reference
            _ = ability.ActivateAbility()
            ability.name = oldAbilityNode.name
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
}

extension Comparable {
    func clamp(min: Self, max: Self) -> Self {
        return Swift.max(min, Swift.min(self, max))
    }
}
