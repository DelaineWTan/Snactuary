//
//  LifecycleManager.swift
//  Pet Bullet Heaven
//
//  Created by Jun Solomon on 2024-02-18.
//

import Foundation

/// Manages the lifecycle of game objects and provides utility methods for their management.
public class LifecycleManager {
    
    // Singleton (hello old friend -Jun) instance
    static let Instance = LifecycleManager()
    
    private init() {}

    // Dictionary to store game objects with their unique IDs
    private var gameObjects = [UUID: MonoBehaviour]()
    private var lastUpdateTime: TimeInterval = 0

    // Method to add a game object to the manager and call its Start method
    func addGameObject(_ gameObject: MonoBehaviour) {
        gameObjects[gameObject.uniqueID] = gameObject
        gameObject.Start()
    }

    // Method to delete a game object from the manager
    func deleteGameObject(gameObject: MonoBehaviour) {
        gameObject.OnDestroy()
        gameObjects.removeValue(forKey: gameObject.uniqueID)
    }

    // Method to delete all food objects from the manager
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
            food!.DestroyExtras?() // Call DestroyExtras closure if available
        }
    }

    // Method to get all food objects from the manager
    public func getAllFood() -> [BaseFoodNode] {
        // Filter out all game objects that are instances of BaseFoodNode
        let foodList = gameObjects.filter { $0.value is BaseFoodNode }
        
        // Convert the filtered dictionary values to an array of BaseFoodNode
        let allFood = foodList.map { $0.value as! BaseFoodNode }
        
        return allFood
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

    // Method to update all game objects (look, deltatime! -Jun)
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
