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
    var DestroyExtras: (() -> Void)?
    
    let mainScene: SCNScene
    
    var elapsedTime: TimeInterval = 0
    var spawnInterval: TimeInterval = 1 //0.2 // Adjust depending on desired spawn rate
    
    let centerDist: Int = 20 // 55 seems to be a good distance away from player
    
    // TODO: Final food balancing sometime
    init(scene: SCNScene) {
        
        self.mainScene = scene
        self.uniqueID = UUID()
        LifecycleManager.Instance.addGameObject(self)
    }
    
    func Update() {
        elapsedTime += Globals.deltaTime
        if elapsedTime >= spawnInterval {
            if !Globals.inMainMenu {
                initSpawning()
            }
            elapsedTime = 0
        }
    }
    
    func initSpawning() {
        var spawnLocationMultiplier: Float = 1
        var quantity = 0
        var food: BaseFoodNode? = nil
        let foodData = selectFoodDataUsingWeights()
        switch foodData.type {
        case "base":
            quantity = 20
            //            herdSpawn(foodData: fi)
        case "directional":
            quantity = 10
        case "flee":
            quantity = 5
        case "roam":
            quantity = 3
        case "treasure":
            spawnLocationMultiplier = 3
            quantity = 1
        default:
            // Maybe have an error model like in GMod XD
            food = BaseFoodNode(foodData: FoodData(
                name: "Carrot",
                type: "base",
                initialSpeed: 3.5,
                health: 5,
                physicsDimensions: SCNVector3(1.5, 3, 1.5),
                hungerValue: 2,
                assetName: "art.scnassets/Food Models/CarrotV2.scn",
                initialEXP: 1,
                EXPGrowth: 1.0,
                healthGrowth: 1.0,
                hungerGrowth: 1.0,
                speedGrowth: 1.0))
        }
        let position = findRandomPosition(spawnMultiplier: 1)
        
        // Spawn multiple foods in an area near position
        for _ in 0..<quantity {
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
            default:
                // Maybe have an error model like in GMod XD
                food = BaseFoodNode(foodData: FoodData(
                    name: "Carrot",
                    type: "base",
                    initialSpeed: 3.5,
                    health: 5,
                    physicsDimensions: SCNVector3(1.5, 3, 1.5),
                    hungerValue: 2,
                    assetName: "art.scnassets/Food Models/CarrotV2.scn",
                    initialEXP: 1,
                    EXPGrowth: 1.0,
                    healthGrowth: 1.0,
                    hungerGrowth: 1.0,
                    speedGrowth: 1.0))
            }
            let randomPosition = generateRandomPositionWithinRadius(center: position, radius: 5)
            food?.position = randomPosition
            
            // Destroy the food after 50 seconds
            food?.Destroy(after: 100.0)
            mainScene.rootNode.addChildNode(food!)
        }
        
    }
    
    func simpleSpawn(spawnLocationMultiplier: Float, food: BaseFoodNode) {
        
        food.position = findRandomPosition(spawnMultiplier: spawnLocationMultiplier)
        
        // Destroy the food after 50 seconds
        food.Destroy(after: 50.0)
        mainScene.rootNode.addChildNode(food)
    }
    
    //    func herdSpawn(foodData: FoodData, quantity: Int) {
    //        let position = findRandomPosition(spawnMultiplier: 1)
    //
    //            // Spawn multiple foods in an area near position
    //            for _ in 0..<quantity {
    //                let randomPosition = generateRandomPositionWithinRadius(center: position, radius: 20)
    ////                let food = BaseFoodNode(foodData: foodData)
    //                food.position = randomPosition
    //
    //                // Destroy the food after 50 seconds
    //                food.Destroy(after: 100.0)
    //                mainScene.rootNode.addChildNode(food)
    //            }
    //    }
    
    func generateRandomPositionAround(position: SCNVector3) -> SCNVector3 {
        // Adjust this range as needed
        let randomX = Float.random(in: position.x - 5.0 ... position.x + 5.0)
        let randomZ = Float.random(in: position.z - 5.0 ... position.z + 5.0)
        let randomPosition = SCNVector3(randomX, position.y, randomZ)
        return randomPosition
    }
    
    func generateRandomPositionWithinRadius(center: SCNVector3, radius: Float) -> SCNVector3 {
        // Generate a random angle
        let randomAngle = Float.random(in: 0...(2 * Float.pi))
        let randomRadius = Float.random(in: 0...radius)
        
        // Calculate random x and z coordinates within the circle
        let randomX = center.x + randomRadius * cos(randomAngle)
        let randomZ = center.z + randomRadius * sin(randomAngle)
        
        let randomPosition = SCNVector3(randomX, center.y, randomZ)
        return randomPosition
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
            assetName: "art.scnassets/Food Models/CarrotV2.scn",
            initialEXP: 1,
            EXPGrowth: 1.0,
            healthGrowth: 1.0,
            hungerGrowth: 1.0,
            speedGrowth: 1.0)
    }
    
    func Start() {
        
    }
    
    func OnDestroy() {
    }
    
    func Destroy(after duration: TimeInterval) {
        
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
