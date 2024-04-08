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
    var spawnInterval: TimeInterval = 0.2 // Adjust depending on desired spawn rate
    
    let centerDist: Int = 55 // 55 seems to be a good distance away from player
    
    init(scene: SCNScene) {
        self.mainScene = scene
        self.uniqueID = UUID()
        LifecycleManager.Instance.addGameObject(self)
    }
    
    func simpleSpawn() {
        
        
        let stageIndex = (UserDefaults.standard.integer(forKey: Globals.stageCountKey) - 1) % 3
        
        let food = GoblinFoodNode(foodData: Globals.basicFoodArray[stageIndex])
        
        
        
        
        food.position = findRandomPosition()
        
        
        
        food.onDestroy = {
            // Do any cleanup or additional tasks before destroying the node
        }
        // Destroy the food after 50 seconds
        food.onDestroy(after: 50.0)
        mainScene.rootNode.addChildNode(food)
    }
    
    
    
    
    
    
    func Start() {
        
    }
    
    func Update() {
        elapsedTime += Globals.deltaTime
        if elapsedTime >= spawnInterval {
            if !Globals.inMainMenu {
                simpleSpawn()
            }
            elapsedTime = 0
        }
    }
    
    func onDestroy(after duration: TimeInterval) {
        
    }
    
    // Choose between the X or Z coordinate of the food's spawn location, and set it to either I or J, respectively.
    // If I is chosen, set it to the negative of the spawn distance from the center; if J is chosen, set it to the spawn distance from the center.
    // The other coordinate (either Z if I is chosen, or X if J is chosen) is set to a random number between A and B, where:
    //   - A is the negative spawn distance from the center, and
    //   - B is the spawn distance from the center.
    func findRandomPosition() -> SCNVector3 {
        let randomFromAtoB = Float(Int.random(in: -centerDist...centerDist))
        
        let randomIorJ = Float(Bool.random() ? -centerDist : centerDist)
        
        let randomPosition = Bool.random() ? SCNVector3(x: randomIorJ, y: 0, z: randomFromAtoB) : SCNVector3(x: randomFromAtoB, y: 0, z: randomIorJ)
        return randomPosition
    }
}
