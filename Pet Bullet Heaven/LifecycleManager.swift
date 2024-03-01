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
    
    private var gameObjects = [Updatable]()
    private var lastUpdateTime: TimeInterval = 0
    
    func addGameObject(_ gameObject: Updatable) {
        gameObjects.append(gameObject)
        gameObject.Start()
    }
    
    func update() {
        let currentTime = Date.timeIntervalSinceReferenceDate
        let deltaTime = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        if Float(deltaTime) > 2 {
                    return
                }
        
        for gameObject in gameObjects {
            gameObject.Update(deltaTime: deltaTime)
        }
    }
}
