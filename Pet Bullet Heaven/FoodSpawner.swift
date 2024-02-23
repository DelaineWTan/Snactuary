//
//  FoodSpawner.swift
//  Pet Bullet Heaven
//
//  Created by Jun Solomon on 2024-02-16.
//

import Foundation
import SceneKit

class FoodSpawner {
    let mainScene: SCNScene
    
    init(scene: SCNScene) {
        self.mainScene = scene
        
        spawn()
        
    }
    
    /// Spawns food nodes, for now it's set to spawn just 3 food. Will eventually spawn food in set intervals
    func spawn() {
        
        // TODO: make A, B, I, and J (maybe even foodCount) be easily modifiable
        let foodCount = 3
        
        for i in 0..<foodCount {
            // There might be some miscalculations here somewhere, I'm just cooked
            
            let randomFromAtoB = Float(Int.random(in: -10...10))

            let randomIorJ = Float(Bool.random() ? 10 : -10)
            
            // Randomly set the X or Z food position to I or J, then set the other a random number between A and B
            let randomPosition = Bool.random() ? SCNVector3(x: randomIorJ, y: 0, z: randomFromAtoB) : SCNVector3(x: randomFromAtoB, y: 0, z: randomIorJ)

            let food = Food(spawnLocation: randomPosition, speed: 1)
            food.position = randomPosition
            //print("food \(i) position: \(food.position)")
            food.onDestroy = {
                // Do any cleanup or additional tasks before destroying the node
                print("Food destroyed!")
            }
            food.onDestroy(after: 10.0) // Destroy the food after 3 seconds
            mainScene.rootNode.addChildNode(food)
        }
    }
}
