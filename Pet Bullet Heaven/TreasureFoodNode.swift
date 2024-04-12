//
//  GoblinFoodNode.swift
//  Pet Bullet Heaven
//
//  Created by Jun Solomon on 2024-04-07.
//

import Foundation
import SceneKit

public class TreasureFoodNode: BaseFoodNode {
    
    var timeElapsed: TimeInterval = 0.0
    let spawnInterval: TimeInterval = 1.0
    
    override init(foodData: FoodData) {
        super.init(foodData: foodData)
        self.onDestroy = {
            print("I'm dead")
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let rangeLimit: Float = 3
    var modifierX: Float = 0.0
    var modifierZ: Float = 0.0
    var roamInterval: TimeInterval = 5.0 // Interval for changing roam
    var timeSinceLastRoam: TimeInterval = 0.0
    
    var timeTillStopElapsed: TimeInterval = 0.0
    var timeTillStop: TimeInterval = 20.0
    
    override func doBehaviour() {
        
        timeTillStopElapsed += Globals.deltaTime
        
        if timeTillStopElapsed >= timeTillStop {
            return
        }
        let directionToCenter = SCNVector3(0, 0, 0) + self.position
        
        // Normalize the direction vector to ensure consistent movement speed
        let normalizedDirection = directionToCenter.normalized()
        
        // Adjust the position based on the direction vector
        self.position.x += (normalizedDirection.x * Float(Globals.deltaTime) * self.speed) * modifierX
        self.position.z += (normalizedDirection.z * Float(Globals.deltaTime) * self.speed) * modifierZ
    }
    
    override func Start() {
        super.Start()
        initializeFoodMovement()
    }
    
    override func Update() {
        super.Update()
        intervalBehaviour()
    }
    
    func intervalBehaviour() {
        // Increment the time elapsed
        timeElapsed += Globals.deltaTime
        
        // Check if it's time to spawn food
        if timeElapsed >= spawnInterval {
            // Reset the time elapsed
            timeElapsed = 0.0
            
            // Spawn the food
            spawnBabyFoods()
        }
        
        timeSinceLastRoam += Globals.deltaTime
        if timeSinceLastRoam >= roamInterval {
            timeSinceLastRoam = 0.0
            initializeFoodMovement()
        }
        
        
    }
    
    func initializeFoodMovement() {
        modifierX = Float.random(in: 1...rangeLimit)
        modifierZ = Float.random(in: 1...rangeLimit)
    }
    
    func spawnBabyFoods() {
        
        let food = BaseFoodNode(foodData: Globals.stage1Foods[1].1)
        
        food.position = self.position
        
        food.onDestroy = {
            // Do any cleanup or additional tasks before destroying the node
        }
        // Destroy the food after 50 seconds
        food.onDestroy(after: 50.0)
        Globals.mainScene.rootNode.addChildNode(food)
    }
}
