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
        if let mainPlayerNode = Globals.mainScene.rootNode.childNode(withName: "mainPlayer", recursively: true) {
            petSlotNode = mainPlayerNode.childNode(withName: "pos\(position)", recursively: true)!
            
            if let oldAbilityNode = mainPlayerNode.childNode(withName: Globals.petAbilityNodeName[position], recursively: true) as? Ability {
                oldAbilityNode.removeFromParentNode()
                oldAbilityNode.deactivate()
            }
            
            petSlotNode.enumerateChildNodes { (node, stop) in
                node.removeFromParentNode()
            }
            petSlotNode.addChildNode(petNode)
            petNode.slotPosition = petSlotNode.position
            
            petNode.activate()
            
            petNode.activeAbility.name = Globals.petAbilityNodeName[position]
            mainPlayerNode.addChildNode(petNode.activeAbility)
            
        }
    }
    
    // Load an SCN model from a .scn file and add it to a node
    public static func loadSceneModelNode(name: String) -> SCNNode {
        
        let n = SCNNode()
        if let foodModelSCN = SCNScene(named: name) {
            // Iterate through all child nodes in the loaded scene and add them to the scene node
            for childNode in foodModelSCN.rootNode.childNodes {
                n.addChildNode(childNode)
            }
        } else {
            print("Failed to load food scene from file.")
        }
        return n
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
//        if (currentUserDataVersion != latestUserDataVersion) {
//            print("User data version out of date (v\(currentUserDataVersion)), initializing to v\(latestUserDataVersion)...")
            UserDefaults.standard.set(0, forKey: Globals.totalScoreKey)
            UserDefaults.standard.set(0, forKey: Globals.stageScoreKey)
            UserDefaults.standard.set(0, forKey: Globals.damageDoneKey)
            UserDefaults.standard.set(0, forKey: Globals.snacksEatenKey)
            UserDefaults.standard.set(0, forKey: Globals.stagesPassedKey)
            UserDefaults.standard.setValue(Globals.defaultActivePets, forKey: Globals.activePetsKey)
        UserDefaults.standard.set(Globals.defaultPetLevels, forKey: Globals.petLevelsKey)
            UserDefaults.standard.set(Globals.defaultStageCount, forKey: Globals.stageCountKey)
            UserDefaults.standard.set(Globals.defaultMaxHungerScore, forKey: Globals.stageMaxScorekey)
            UserDefaults.standard.set(Globals.foodHealthMultiplierKey, forKey: Globals.foodHealthMultiplierKey)
            
            UserDefaults.standard.set(latestUserDataVersion, forKey: Globals.userDataVersionKey)
      //  }
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
            Globals.currentGameState = "paused"
        case "mainMenu":
            Globals.timeScale = 0
            Globals.inMainMenu = true
            LifecycleManager.Instance.deleteAllFood()
            Globals.currentGameState = "mainMenu"
        case "inGame":
            Globals.timeScale = 1
            Globals.inMainMenu = false
            Globals.currentGameState = "inGame"
        default:
            Globals.timeScale = 1
        }
    }
    
    // Calculate the distance between the two positions
    static func distanceBetween(vector1: SCNVector3, vector2: SCNVector3) -> Float {
        let dx = vector2.x - vector1.x
        let dy = vector2.y - vector1.y
        let dz = vector2.z - vector1.z
        
        return sqrt(dx*dx + dy*dy + dz*dz)
    }
    
    // Fetches the current cycle of stages currently. E.g.: With 3 total stages, a cycle is 3. if stage count is 8, we are on the 2nd cycle of the stages.
    static func getCurrentStageIteration() -> Int {
        let stageCount = UserDefaults.standard.integer(forKey: Globals.stageCountKey)
        let iteration = (stageCount + Globals.numStagePresets - 1) / Globals.numStagePresets // rounds up
        return iteration
    }
    
    /// Calculates current stat based upon the stage count, base, and growth of a given stat. Always rounds down.
    public static func finalStatCalculation(stageCycle: Int, baseStat: Int, growth: Float) -> Int {
        let calc = (Float(baseStat) * Float(stageCycle)) * growth
        return Int(calc)
    }
    
    /// Calculates current stat based upon the stage count, base, and growth of a given stat. Always rounds down.
    public static func finalStatCalculation(stageCycle: Int, baseStat: Float, growth: Float) -> Float {
        return (baseStat * Float(stageCycle)) * growth
    }
    
    // Levitate pets and fade to white over a given time
    public static func levitatePetsAndFadeScreenCutscene(duration: Double, _ stageMat: inout SCNMaterial) {
        // Define the target height
        let targetHeight: Float = 10 // Adjust the target height as needed
        
        // Define the duration for the animation
        let durationInSeconds: TimeInterval = duration // Adjust the duration as needed
        
        // Calculate the distance to move per frame
        let distanceToMovePerFrame = (targetHeight - Globals.playerNode.position.y) / (Float(durationInSeconds) * 60)
        
        // Create a white view for screen fade
        let whiteView = UIView(frame: UIScreen.main.bounds)
        whiteView.backgroundColor = .white
        whiteView.alpha = 0 // Start with transparent
        
        // Add the white view to the key window
        UIApplication.shared.keyWindow?.addSubview(whiteView)
        
        // Create a local mutable variable to hold the reference to material
        var mutableMaterial = stageMat
        
        // Create a timer to update the pet's position and fade the screen over time
        var timeElapsed: TimeInterval = 0
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60, repeats: true) { timer in
            // Increment the time elapsed
            timeElapsed += 1.0 / 60
            
            // Update the pet's position
            Globals.playerNode.position.y += distanceToMovePerFrame
            
            // Calculate the alpha value for screen fade
            let alpha = CGFloat(timeElapsed / (durationInSeconds - 1.5))
            
            // Set the alpha value of the white view
            whiteView.alpha = alpha
            
            // Check if the animation duration has been reached
            if timeElapsed >= durationInSeconds {
                // Invalidate the timer to stop the animation
                timer.invalidate()
                
                // Update stage appearance
                StageAestheticsHelper.iterateStageVariation(&mutableMaterial)
                Globals.playerNode.position.y = 0
                
                // Remove the white view from the screen
                whiteView.removeFromSuperview()
            }
        }
    }



}

extension SCNVector3 {
    static func - (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3(left.x - right.x, left.y - right.y, left.z - right.z)
    }
    
    static func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3(left.x + right.x, left.y + right.y, left.z + right.z)
    }
    
    func normalized() -> SCNVector3 {
        let length = sqrt(x * x + y * y + z * z)
        return SCNVector3(x / length, y / length, z / length)
    }
}

extension Comparable {
    func clamp(min: Self, max: Self) -> Self {
        return Swift.max(min, Swift.min(self, max))
    }
}

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex >> 16) & 0xFF) / 255.0
        let green = CGFloat((hex >> 8) & 0xFF) / 255.0
        let blue = CGFloat(hex & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
