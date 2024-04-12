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
    
    // TODO: Final food balancing sometime
    init(scene: SCNScene) {
        foodArray = [
            FoodData(
                name: "Carrot",
                initialSpeed: 0.5,
                health: 3,
                physicsDimensions: SCNVector3(1.5, 3, 1.5),
                hungerValue: 2,
                assetName: "art.scnassets/Food Models/CarrotV2.scn",
                initialEXP: 1,
                EXPGrowth: 1.0,
                healthGrowth: 1.0,
                hungerGrowth: 1.0,
                speedGrowth: 1.0),
            
            FoodData(
                name: "Banana",
                initialSpeed: 3,
                health: 3,
                physicsDimensions: SCNVector3(x: 3, y: 3, z: 3),
                hungerValue: 4,
                assetName: "art.scnassets/Banana.scn",
                initialEXP: 1,
                EXPGrowth: 1.0,
                healthGrowth: 1.0,
                hungerGrowth: 1.0,
                speedGrowth: 1.0),
            
            FoodData(
                name: "Donut",
                initialSpeed: 2,
                health: 10,
                physicsDimensions: SCNVector3(3, 3, 3),
                hungerValue: 8,
                assetName: "art.scnassets/Food Models/Donut.scn",
                initialEXP: 1,
                EXPGrowth: 1.0,
                healthGrowth: 1.0,
                hungerGrowth: 1.0,
                speedGrowth: 1.0)
        ]
        self.mainScene = scene
        self.uniqueID = UUID()
        LifecycleManager.Instance.addGameObject(self)
    }
    
    func simpleSpawn() {
        
        var spawnMultiplier: Float = 1
        
        var food: BaseFoodNode? = nil
        let foodData = selectFoodDataUsingWeights()
        switch foodData.type {
        case "base":
            food = BaseFoodNode(foodData: foodData)
        case "directional":
            food = DirectionalFood(foodData: foodData)
        case "flee":
            food = FleeingFoodNode(foodData: foodData)
        case "roam":
            food = RoamingFoodNode(foodData: foodData)
        case "treasure":
            food = TreasureFoodNode(foodData: foodData)
            spawnMultiplier = 3
        default:
            // Maybe have an error model like in GMod XD
            food = BaseFoodNode(foodData: FoodData(
                name: "Carrot",
                type: "base",
                initialSpeed: 3.5,
                health: 5,
                physicsDimensions: SCNVector3(1.5, 3, 1.5),
                hungerValue: 2,
                assetName: "art.scnassets/Food Models/CarrotV2.scn"))
        }
        
        food!.position = findRandomPosition(spawnMultiplier: spawnMultiplier)

        
        food!.onDestroy = {
            // Do any cleanup or additional tasks before destroying the node
        }
        // Destroy the food after 50 seconds
        food!.onDestroy(after: 50.0)
        mainScene.rootNode.addChildNode(food!)
    }
    
    
    func selectFoodDataUsingWeights() -> FoodData {
        let stageIndex = (UserDefaults.standard.integer(forKey: Globals.stageCountKey) - 1) % 3
        let foodGroup = Globals.foodGroups[stageIndex]
        
        let totalWeight = foodGroup.reduce(0) { (result, tuple) in
            let (weight, _) = tuple
            return result + weight
        }
        
        let randomNumber = Int.random(in: 1...totalWeight)
        var cumulativeWeight = 0

        for ((weight, foodData)) in foodGroup {
            cumulativeWeight += weight
            if cumulativeWeight >= randomNumber {
                return foodData
            }
        }

        // should never go here!
        return FoodData(
            name: "Carrot",
            type: "base",
            initialSpeed: 3.5,
            health: 5,
            physicsDimensions: SCNVector3(1.5, 3, 1.5),
            hungerValue: 2,
            assetName: "art.scnassets/Food Models/CarrotV2.scn")
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
    
    // Choose either the X or Z coordinate of the food's spawn location and set it to either I or J, respectively.
    // If I is chosen, set it to the negative spawn distance from the center; if J is chosen, set it to the spawn distance from the center.
    // The other coordinate (either Z if I is chosen, or X if J is chosen) is set to a random number between A and B.
    // A is the negative spawn distance from the center, and B is the spawn distance from the center.
    func findRandomPosition(spawnMultiplier: Float) -> SCNVector3 {
        let randomFromAtoB = Float(Int.random(in: -centerDist...centerDist)) * spawnMultiplier
        
        let randomIorJ = Float(Bool.random() ? -centerDist : centerDist) * spawnMultiplier
        
        let randomPosition = Bool.random() ? SCNVector3(x: randomIorJ, y: 0, z: randomFromAtoB) : SCNVector3(x: randomFromAtoB, y: 0, z: randomIorJ)
        return randomPosition
    }
}
