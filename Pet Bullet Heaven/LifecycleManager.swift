//
//  LifecycleManager.swift
//  Pet Bullet Heaven
//
//  Created by Jun Solomon on 2024-02-18.
//

import Foundation

public class LifecycleManager {
    
    // Singleton (not again) instance
    static let Instance = LifecycleManager()
    
    private init() {}
    
    private var gameObjects = [UUID: MonoBehaviour]()
    private var lastUpdateTime: TimeInterval = 0
    
    func addGameObject(_ gameObject: MonoBehaviour) {
        gameObjects[gameObject.uniqueID] = gameObject
        gameObject.Start()
    }
    
    func deleteGameObject(gameObject: MonoBehaviour) {
        gameObjects.removeValue(forKey: gameObject.uniqueID)
    }
    
    func deleteAllFood() {
        let foodToRemove = gameObjects.filter { $0.value is BaseFoodNode }
        
        // Remove the filtered objects from the dictionary
        for (_, object) in foodToRemove {
            deleteGameObject(gameObject: object)
            let food = object as? BaseFoodNode
            
            // Perform any additional cleanup or actions as needed
            food?.removeFromParentNode()
            food?.childNodes.forEach {
                $0.removeFromParentNode()
            }
            food!.onDestroy?()
        }
    }
    
    func getClosestFood() -> (BaseFoodNode?, Float) {
        
        // Get a list of all the Food in the Scene
        let _FoodList = gameObjects.filter{ $0.value is BaseFoodNode }
        
        // Track closest distance starting at max float value.
        var closestDistance = Float.greatestFiniteMagnitude
        
        // Food Node to return
        var closestFoodNode : BaseFoodNode?
        
        // TODO: Check all the food at Linear Time for the closest food to (SCNVector3(0,0,0))
        for (_, object) in _FoodList {
            
            // Get the FoodNode
            let thisFoodNode = object as? BaseFoodNode
            
            // Calculate the magnitude from (0,0,0)
            let distanceToFoodNode = sqrt(pow((thisFoodNode?.position.x)!, 2) + pow((thisFoodNode?.position.z)!, 2))
            
            // Compare the distance and keep the lower one.
            if (distanceToFoodNode < closestDistance){
                closestFoodNode = thisFoodNode
                closestDistance = distanceToFoodNode
            }
            
        }
        
        // There will always be a closest FoodNode, we're going to check if its range is valid later.
        return (closestFoodNode, closestDistance)
        
    }
    
    func update() {
        let currentTime = Date.timeIntervalSinceReferenceDate
        let deltaTime = (currentTime - lastUpdateTime) * Globals.timeScale
        lastUpdateTime = currentTime
        if Float(deltaTime) > 2 {
            return
        }
        
        Globals.deltaTime = deltaTime
        for gameObject in gameObjects.values {
            gameObject.Update()
        }
    }
}
