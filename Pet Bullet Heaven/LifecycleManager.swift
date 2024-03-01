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
        //gameObjects.append(gameObject)
        //let uuid = UUID()
        //print(uuid.uuidString) // This will print a unique identifier
        //gameObject.uniqueID = uuid // Set the uniqueID of the gameObject
        //gameObject.setUUID()
        gameObjects[gameObject.uniqueID] = gameObject
        print("printing uniqueIDs v")
        for gameObject in gameObjects.values {
            print("\(gameObject.uniqueID )")
        }
        gameObject.Start()
    }
    
    func deleteGameObject(gameObject: MonoBehaviour) {
//            if let index = gameObjects.firstIndex(where: { $0 === gameObject }) {
//                gameObjects.remove(at: index)
//            }
//        for (index, existingObject) in gameObjects.enumerated() {
//            if gameObject === existingObject {
//                gameObjects.remove(at: index)
//                break // Exit loop after removing the object
//            }
//        }
        gameObjects.removeValue(forKey: gameObject.uniqueID)
        print("printing uniqueIDs v")
        for gameObject in gameObjects.values {
            print("\(gameObject.uniqueID ) tits tits")
        }
    }
    
    func update() {
        let currentTime = Date.timeIntervalSinceReferenceDate
        let deltaTime = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        if Float(deltaTime) > 2 {
                    return
                }
        
//        for gameObject in gameObjects {
//            gameObject.Update(deltaTime: deltaTime)
//        }
        for gameObject in gameObjects.values {
            gameObject.Update(deltaTime: deltaTime)
        }
    }
}
