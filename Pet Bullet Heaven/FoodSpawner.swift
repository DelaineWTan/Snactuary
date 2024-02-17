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
    
    func spawn() {
        
        // TODO: make A, B, I, and J (maybe even foodCount) be easily modifiable
        let foodCount = 3
        
        for i in 0..<foodCount {
            
            // There might be some miscalculations here somewhere, therefore I'm cooked
            let isPositive = Bool.random()

            let randomFromAtoB = Float(Int.random(in: -10...10))

            let randomIorJ = Float(isPositive ? 10 : -10)
            
            let randomPosition = isPositive ? SCNVector3(x: randomIorJ, y: 0, z: randomFromAtoB) : SCNVector3(x: randomFromAtoB, y: 0, z: randomIorJ)

            // TODO: the increment's really low for now, we might need a deltaTime for us to properly calculate physics and movement, but this will do for now
            let food = Food(spawnLocation: randomPosition, increment: 0.00001)
            food.position = randomPosition
            print("food \(i) position: \(food.position)")
            mainScene.rootNode.addChildNode(food)
        }
    }
}
