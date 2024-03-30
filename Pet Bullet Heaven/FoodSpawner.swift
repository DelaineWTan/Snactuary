//
//  FoodSpawner.swift
//  Pet Bullet Heaven
//
//  Created by Jun Solomon on 2024-02-16.
//

import Foundation
import SceneKit

class FoodSpawner: MonoBehaviour {
    var uniqueID: UUID
    var onDestroy: (() -> Void)?
    
    let mainScene: SCNScene
    
    var elapsedTime: TimeInterval = 0
    var spawnInterval: TimeInterval = 0.3 // Adjust depending on desired spawn rate
    
    let centerDist: Int = 55 // 55 seems to be a good distance away from player
    let foodArray: [FoodData]
    
    init(scene: SCNScene) {
        foodArray = [
            FoodData(name: "Carrot", initialSpeed: 1, health: 1, physicsDimensions: SCNVector3(1.5, 3, 1.5), hungerValue: 2, assetName: "art.scnassets/Food Models/CarrotV2.scn"),
            FoodData(name: "Banana", initialSpeed: 1, health: 1, physicsDimensions: SCNVector3(x: 3, y: 3, z: 3), hungerValue: 2, assetName: "art.scnassets/Banana.scn"),
            FoodData(name: "Donut", initialSpeed: 0.5, health: 2, physicsDimensions: SCNVector3(3, 3, 3), hungerValue: 10, assetName: "art.scnassets/Food Models/Donut.scn")
        ]
        self.mainScene = scene
        self.uniqueID = UUID()
        LifecycleManager.Instance.addGameObject(self)
    }
    
    func simpleSpawn() {
        
        let randomFromAtoB = Float(Int.random(in: -centerDist...centerDist))
        
        let randomIorJ = Float(Bool.random() ? -centerDist : centerDist)
        
        // Choose between the X or Z coordinate of the food's spawn location, and set it to either I or J, respectively.
        // If I is chosen, set it to the negative of the spawn distance from the center; if J is chosen, set it to the spawn distance from the center.
        // The other coordinate (either Z if I is chosen, or X if J is chosen) is set to a random number between A and B, where:
        //   - A is the negative spawn distance from the center, and
        //   - B is the spawn distance from the center.
        let randomPosition = Bool.random() ? SCNVector3(x: randomIorJ, y: 0, z: randomFromAtoB) : SCNVector3(x: randomFromAtoB, y: 0, z: randomIorJ)
        
        let foodIndex = (UserDefaults.standard.integer(forKey: Globals.stageCountKey) - 1) % 3
        
        let food = FoodNode(spawnLocation: randomPosition, speed: Float(Int.random(in: 1...2)), foodData: foodArray[foodIndex])
        
        food.onDestroy = {
            // Do any cleanup or additional tasks before destroying the node
        }
        // Destroy the food after 50 seconds
        food.onDestroy(after: 50.0)
        mainScene.rootNode.addChildNode(food)
    }
    
    func Start() {
        
    }
    
    func Update(deltaTime: TimeInterval) {
        elapsedTime += deltaTime
        if elapsedTime >= spawnInterval {
            simpleSpawn()
            elapsedTime = 0
        }
    }
    
    func onDestroy(after duration: TimeInterval) {
        
    }
}
