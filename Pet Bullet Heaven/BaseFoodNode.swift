//
//  Food.swift
//  Pet Bullet Heaven
//
//  Created by Jun Solomon on 2024-02-14.
//

import Foundation
import SceneKit


///
/// Rudimentary Food Class
///
///
public class BaseFoodNode : SCNNode, MonoBehaviour {
    
    var uniqueID: UUID
    var DestroyExtras: (() -> Void)? // Closure to be called when the node is destroyed
    
    var deltaTime : CFTimeInterval = 0
    var previousTimestamp: CFTimeInterval = 0
    let foodCategory: Int = 0b010
    
    var _Health : Int = Globals.defaultFoodHealth
    var hungerValue: Int = Globals.defaultFoodHungerValue
    var exp: Int = 1
    var speed : Float
    
    var foodData: FoodData
    
    init(foodData: FoodData) {
        let stageIteration = Utilities.getCurrentStageIteration()
        // calc food stats with base stats and their growths
        self._Health = Utilities.finalStatCalculation(stageCycle: stageIteration, baseStat: foodData.health, growth: foodData.healthGrowth)
        self.exp = Utilities.finalStatCalculation(stageCycle: stageIteration, baseStat: foodData.initialEXP, growth: foodData.EXPGrowth)
        self.speed = Utilities.finalStatCalculation(stageCycle: stageIteration, baseStat: foodData.initialSpeed, growth: foodData.speedGrowth)
        self.hungerValue = Utilities.finalStatCalculation(stageCycle: stageIteration, baseStat: foodData.hungerValue, growth: foodData.hungerGrowth)
        self.uniqueID = UUID() // make sure every class that has an Updatable has this unique ID in its init
        self.foodData = foodData
        super.init()
        
        LifecycleManager.Instance.addGameObject(self)
        
        // load scene model
        // TODO: use .clone() to do object instancing
        
        self.addChildNode((Globals.foodSCNModels[foodData.assetName]!.clone()))

        
        // handle all physics and rendering
        initializeBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeBody() {
        let foodPhysicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: SCNBox(width: CGFloat(foodData.physicsDimensions.x), height: CGFloat(foodData.physicsDimensions.x), length: CGFloat(foodData.physicsDimensions.x), chamferRadius: 0), options: nil)) // Create a dynamic physics body
        
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
    }
    
    func Start() {
    }
    
    func OnDestroy() {
    }
    
    func Update() {
        moveWithWorld()
        doBehaviour()
        despawnBehaviour()
    }
    
    func moveWithWorld() {
        // Move food relative to the player
        if Globals.playerIsMoving {
            let translationVector = SCNVector3(Float(Globals.inputX) * Globals.playerMovementSpeed * Float(Globals.deltaTime), 0, Float(Globals.inputZ) * Globals.playerMovementSpeed * Float(Globals.deltaTime))
            
            self.position.x += translationVector.x
            self.position.z += translationVector.z
        }
    }
    
    /// Moves the food away from the player, mindless behaviour -Jun
    func doBehaviour() {
        // no behaviour
    }
    
    func despawnBehaviour() {
        // Check if the object's distance from the center is greater than 100 meters
        let distanceFromCenter = sqrt(pow(self.position.x, 2) + pow(self.position.z, 2))
        if distanceFromCenter > 500 {
            // If the object is more than 100 meters away from the center, destroy it
            self.Destroy(after: 0)
        }
    }
}


public class DirectionalFood: BaseFoodNode {
    
    let rangeLimit = 1
    var modifierX : Float = 0.0
    var modifierZ : Float = 0.0
    
    override func Start() {
        initializeFoodMovement()
    }
    
    override func Update() {
        super.Update()
        
    }
    func initializeFoodMovement() {
        
        if self.position.x > 0 {
            modifierX = Float(Int.random(in: 1...rangeLimit))
        } else {
            modifierX = Float(Int.random(in: -rangeLimit...1))
        }
        if self.position.z > 0 {
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
    
    /// Moves the food away from the player in one direction
    override func doBehaviour() {
        self.position.x += modifierX * Float(Globals.deltaTime) * self.speed
        self.position.z += modifierZ * Float(Globals.deltaTime) * self.speed
    }
}

public class FleeingFoodNode: BaseFoodNode {
    override func doBehaviour() {
        let directionToCenter = SCNVector3(0, 0, 0) - self.position
            
            // Normalize the direction vector to ensure consistent movement speed
            let normalizedDirection = directionToCenter.normalized()
            
            // Adjust the position based on the direction vector
            self.position.x -= normalizedDirection.x * Float(Globals.deltaTime) * self.speed
            self.position.z -= normalizedDirection.z * Float(Globals.deltaTime) * self.speed
    }
}

public class RoamingFoodNode: BaseFoodNode {
    
    let rangeLimit: Float = 1
    var modifierX: Float = 0.0
    var modifierZ: Float = 0.0
    var roamInterval: TimeInterval = 5.0 // Interval for changing roam direction
    var timeSinceLastRoam: TimeInterval = 0.0
    
    override func Start() {
        super.Start()
        initializeFoodMovement()
    }
    
    override func Update() {
        super.Update()
        
        timeSinceLastRoam += Globals.deltaTime
        if timeSinceLastRoam >= roamInterval {
            timeSinceLastRoam = 0.0
            initializeFoodMovement()
        }
    }
    
    func initializeFoodMovement() {
        modifierX = Float.random(in: -rangeLimit...rangeLimit)
        modifierZ = Float.random(in: -rangeLimit...rangeLimit)
    }
    
    /// Moves the food in a random direction
    override func doBehaviour() {
        self.position.x += modifierX * Float(Globals.deltaTime) * self.speed
        self.position.z += modifierZ * Float(Globals.deltaTime) * self.speed
    }
}

