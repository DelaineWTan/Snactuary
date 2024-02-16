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
    let spawnPositions: [SCNVector3]
    
    init(scene: SCNScene, spawnPositions: [SCNVector3]) {
        self.mainScene = scene
        self.spawnPositions = spawnPositions
        
        spawn()
        
    }
    
    func spawn() {
        let foodCount = 3
        
        for _ in 0..<foodCount {
            let randomIndex = Int.random(in: 0..<spawnPositions.count)
            let position = spawnPositions[randomIndex]
            
            let food = Food()
            food.position = position
            print("food spawned in location: \(position)")
            mainScene.rootNode.addChildNode(food)
            food.Move(increment: -1)
        }
    }
}
