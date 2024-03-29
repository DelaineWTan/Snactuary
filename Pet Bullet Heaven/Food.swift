//
//  Food.swift
//  Pet Bullet Heaven
//
//  Created by Jun Solomon on 2024-02-14.
//

import Foundation
import SceneKit


struct FoodData {
    var name: String
    var initialSpeed: Float
    var physicsDimensions: SCNVector3
    var hungerValue: Int
    var assetName: String
}
///
/// Rudimentary Food Class
///
public class Food : SCNNode, MonoBehaviour {
    
    var uniqueID: UUID
    
    var onDestroy: (() -> Void)? // Closure to be called when the node is destroyed
    
    var _Health : Int = Globals.defaultFoodHealth
    
    var spawnLocation : SCNVector3
    var speed : Float
    
    var deltaTime : CFTimeInterval = 0
    var previousTimestamp: CFTimeInterval = 0
    var hungerValue: Int = Globals.defaultFoodHungerValue
    
    let foodCategory: Int = 0b010

    init(spawnLocation: SCNVector3, speed: Float, foodData: FoodData) {
        
        self.spawnLocation = spawnLocation
        self.speed = speed
        self.hungerValue = foodData.hungerValue
        self._Health = foodData.health * UserDefaults.standard.integer(forKey: Globals.stageCountKey)
        self.uniqueID = UUID() // make sure every class that has an Updatable has this unique ID in its init
        super.init()
        self.position = spawnLocation
        
        LifecycleManager.Instance.addGameObject(self)

        let n = SCNNode()
        if let foodModelSCN = SCNScene(named: foodData.assetName) {
            // Iterate through all child nodes in the loaded scene and add them to the scene node
            for childNode in foodModelSCN.rootNode.childNodes {
                n.addChildNode(childNode)
                //print("mesh adding")
            }
        } else {
            print("Failed to load food scene from file.")
        }
        
        //_Mesh = referenceNode
        self.addChildNode(n)

        
        let foodPhysicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: SCNBox(width: CGFloat(foodData.physicsDimensions.x), height: CGFloat(foodData.physicsDimensions.x), length: CGFloat(foodData.physicsDimensions.x), chamferRadius: 0), options: nil)) // Create a dynamic physics body
        
        foodPhysicsBody.mass = 1.0 // Set the mass of the physics body
        foodPhysicsBody.isAffectedByGravity = false
        
        let angleInDegrees: Float = 45.0
                let angleInRadians = angleInDegrees * .pi / 180.0
        self.eulerAngles = SCNVector3(0, angleInRadians, 0)
        //attach physics to food object
        self.physicsBody = foodPhysicsBody
        self.physicsBody?.categoryBitMask = foodCategory
        self.physicsBody?.collisionBitMask = -1
        self.physicsBody?.contactTestBitMask = 1
        
        initializeFoodMovement()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func Start() {
    }
    
    func Update(deltaTime: TimeInterval) {
        move(deltaTime: deltaTime)
        
        // Check if the object's distance from the center is greater than 100 meters
        let distanceFromCenter = sqrt(pow(self.position.x, 2) + pow(self.position.z, 2))
        if distanceFromCenter > 100 {
            // If the object is more than 100 meters away from the center, destroy it
            self.onDestroy(after: 0)
        }
    }
    
    
    let rangeLimit = 5
    var modifierX : Float = 0.0
    var modifierZ : Float = 0.0
    func initializeFoodMovement() {

        if spawnLocation.x > 0 {
            modifierX = Float(Int.random(in: 1...rangeLimit))
        } else {
            modifierX = Float(Int.random(in: -rangeLimit...1))
        }
        if spawnLocation.z > 0 {
            modifierZ = Float(Int.random(in: 1...rangeLimit))
        } else {
            modifierZ = Float(Int.random(in: -rangeLimit...1))
        }
        
        // not sure if this works properly
        let invertChance = 1 // Chance out of 20 to invert modifiers

        if Int.random(in: 1...20) <= invertChance {
            modifierX *= -1
            modifierZ *= -1
        }
    }
    
    /// Moves the food randomly away from the player and relative to the player's inputs
    func move(deltaTime: TimeInterval) {

        self.position.x += modifierX * Float(deltaTime) * self.speed
        self.position.z += modifierZ * Float(deltaTime) * self.speed
        
        
        // Move food relative to the player
        if Globals.playerIsMoving {
            let translationVector = SCNVector3(Float(Globals.inputX) * Globals.playerMovementSpeed * Float(deltaTime), 0, Float(Globals.inputZ) * Globals.playerMovementSpeed * Float(deltaTime))
            
            self.position.x += translationVector.x
            self.position.z += translationVector.z
        }
    }
}
