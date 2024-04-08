//
//  GoblinFoodNode.swift
//  Pet Bullet Heaven
//
//  Created by Jun Solomon on 2024-04-07.
//

import Foundation
import SceneKit

public class GoblinFoodNode: BaseFoodNode {
    
    var timeElapsed: TimeInterval = 0.0
    let spawnInterval: TimeInterval = 1.0
    
    override init(foodData: FoodData) {
        super.init(foodData: foodData)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func doBehaviour() {
        //super.doBehaviour()
        let directionToCenter = SCNVector3(0, 0, 0) - self.position
            
            // Normalize the direction vector to ensure consistent movement speed
            let normalizedDirection = directionToCenter.normalized()
            
            // Adjust the position based on the direction vector
            self.position.x -= normalizedDirection.x * Float(Globals.deltaTime) * self.speed
            self.position.z -= normalizedDirection.z * Float(Globals.deltaTime) * self.speed
    }
    
    override func Update() {
        super.Update()
        // Increment the time elapsed
        timeElapsed += Globals.deltaTime
        
        // Check if it's time to spawn food
        if timeElapsed >= spawnInterval {
            // Reset the time elapsed
            timeElapsed = 0.0
            
            // Spawn the food
            spawnBabyFoods()
        }
    }
    
    @objc func spawnBabyFoods() {
        let food = BaseFoodNode(foodData: FoodData(name: "baby", initialSpeed: 1, health: 1, physicsDimensions: SCNVector3(x: 1, y: 1, z: 1), hungerValue: 1, assetName: "art.scnassets/Banana.scn"))
        
        food.onDestroy = {
            // Do any cleanup or additional tasks before destroying the node
        }
        // Destroy the food after 50 seconds
        food.onDestroy(after: 50.0)
        Globals.mainScene.rootNode.addChildNode(food)
    }
}
