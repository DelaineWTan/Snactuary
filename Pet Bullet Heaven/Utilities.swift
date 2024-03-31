//
//  Utility.swift
//  Pet Bullet Heaven
//
//  Created by Jun Solomon on 2024-03-31.
//

import Foundation
import SceneKit

public class Utilities {
    // Implement the delegate method
    static func swapSceneNode(with petModel: Pet, position: Int, rootScene: SCNNode) {
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
        var petPos = SCNNode()
        var oldAbilityNode = SCNNode()
        if let mainPlayerNode = rootScene.childNode(withName: "mainPlayer", recursively: true) {
            petPos = mainPlayerNode.childNode(withName: "pos\(position)", recursively: true)!
            oldAbilityNode = mainPlayerNode.childNode(withName: Globals.petAbilityNodeName[position], recursively: true)!
            
            petNode.position = petPos.position
            petNode.orientation = petPos.orientation
            petNode.scale = petPos.scale
            petNode.name = petPos.name // TODO: change node names to like pet1 instead of Cat.001 reference when initializing
            
            mainPlayerNode.addChildNode(petNode) // add new pet model node
            petPos.removeFromParentNode()
            
            
            oldAbilityNode.removeFromParentNode()
            
            let ability = petModel.attackPattern.copy() as! Ability // add new pet ability node, create a duplicate of the reference
            _ = ability.ActivateAbility()
            ability.name = oldAbilityNode.name
            mainPlayerNode.addChildNode(ability)
            
        } else {
            print("Failed to load the scene.")
        }
    }
}

extension Comparable {
    func clamp(min: Self, max: Self) -> Self {
        return Swift.max(min, Swift.min(self, max))
    }
}
