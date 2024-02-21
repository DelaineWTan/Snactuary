//
//  Food.swift
//  Pet Bullet Heaven
//
//  Created by Jun Solomon on 2024-02-14.
//

import Foundation
import SceneKit

///
/// Rudimentary Food Class
///
class Food : SCNNode, Updatable {
    
    
    var _Health : Int = 1
    
    var _Mesh : SCNBox?
    
    var spawnLocation : SCNVector3
    var speed : Float
    
    var deltaTime : CFTimeInterval = 0
    var previousTimestamp: CFTimeInterval = 0
    
    init(spawnLocation: SCNVector3, speed: Float) {
        
        self.spawnLocation = spawnLocation
        self.speed = speed
        super.init()
        
        LifecycleManager.shared.addGameObject(self)
        
        let cubeGeometry = SCNBox(width: 0.7, height: 0.7, length: 0.7, chamferRadius: 0.2)
        
        let cubeNode = SCNNode(geometry: cubeGeometry)
        
        // will be changed to whatever the model is
        cubeNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/goldblock.png")
        
        cubeNode.position = SCNVector3(0, 0.5, 0)
        
        let angleInDegrees: Float = 45.0
        let angleInRadians = angleInDegrees * .pi / 180.0
        cubeNode.eulerAngles = SCNVector3(0, angleInRadians, 0)
        self.addChildNode(cubeNode)
        
        self._Mesh = cubeGeometry
        
        
//        Task {
//            await firstUpdate()
//        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func Start() {
    }
    
    var count = 0
    func Update(deltaTime: TimeInterval) {
        //print("deltatime: \(deltaTime)")
        //print("counter in food: \(count)")
        count += 1
        move(deltaTime: deltaTime)
    }
    
    // TODO: add modifiable duration and increment
    /// Moves the food randomly towards the player and relative to the player's inputs
    func move(deltaTime: TimeInterval) {
        
        // TODO: make it work with new deltaTime
        var modifierX : Float = 0.0
        var modifierZ : Float = 0.0
        
        // can't tell if working properly or not
        let randomXVariation = Float.random(in: -3.0...3.0)
        let randomZVariation = Float.random(in: -3.0...3.0)

        if spawnLocation.x > 0 {
            modifierX = Float(-2 + randomXVariation)
        } else {
            modifierX = Float(2 + randomXVariation)
        }
        if spawnLocation.z > 0 {
            modifierZ = Float(-2 + randomZVariation)
        } else {
            modifierZ = Float(2 + randomZVariation)
        }

        //self.speed = 0
        //self.position.x += Float(self.speed * Float(deltaTime))
        //self.position.z += Float(self.speed * Float(deltaTime) * 3)
        print("pos: \(position.x), \(position.z)")
        let playerSpeed : Float = 100
        // Move food relative to the player
        if Globals.playerIsMoving {
            let translationVector = SCNVector3(Float(Globals.rawInputX) / 100 * playerSpeed, 0, Float(Globals.rawInputZ) / 100 * playerSpeed)
            
            self.position.x += translationVector.x
            self.position.z += translationVector.z
        }
    }
    
}
