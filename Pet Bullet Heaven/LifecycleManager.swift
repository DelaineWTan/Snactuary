//
//  LifecycleManager.swift
//  Pet Bullet Heaven
//
//  Created by Jun Solomon on 2024-02-18.
//

import Foundation

public class LifecycleManager {
    
    // Singleton (not again) instance
    static let shared = LifecycleManager()
    
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
