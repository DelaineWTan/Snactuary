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
        let foodToRemove = gameObjects.filter { $0.value is Food }
        
        // Remove the filtered objects from the dictionary
        for (id, object) in foodToRemove {
            deleteGameObject(gameObject: object)
            let food = object as? Food
            
            // Perform any additional cleanup or actions as needed
            food?.removeFromParentNode()
            food!.onDestroy?()
        }
    }
    
    func update() {
        let currentTime = Date.timeIntervalSinceReferenceDate
        let deltaTime = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        if Float(deltaTime) > 2 {
                    return
                }
        
        for gameObject in gameObjects.values {
            gameObject.Update(deltaTime: deltaTime)
        }
    }
}
