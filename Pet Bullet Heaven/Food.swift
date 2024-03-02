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
class Food : SCNNode {
    
    var _Health : Int = 1
    
    var _Mesh : SCNBox?
    
    var spawnLocation : SCNVector3
    var increment : CGFloat
    
    var deltaTime : CFTimeInterval = 0
    var previousTimestamp: CFTimeInterval = 0
    
    let foodCategory: Int = 0b010
    
    init(spawnLocation: SCNVector3, increment: CGFloat) {
        self.spawnLocation = spawnLocation
        self.increment = increment
        super.init()
        
        
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
        
        let foodPhysicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: SCNBox(width: 0.7, height: 0.7, length: 0.7, chamferRadius: 0.2), options: nil)) // Create a dynamic physics body
        foodPhysicsBody.mass = 1.0 // Set the mass of the physics body
        foodPhysicsBody.isAffectedByGravity = false
        
        //attach physics to food object
        self.physicsBody = foodPhysicsBody
        self.physicsBody?.categoryBitMask = foodCategory
        self.physicsBody?.collisionBitMask = -1
        self.physicsBody?.contactTestBitMask = 1
        
        
        Task {
            await firstUpdate()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // TODO: add modifiable duration and increment
    /// Moves the food randomly towards the player and relative to the player's inputs
    func move() {
        
        var modifierX = 0.0
        var modifierZ = 0.0
        
        // can't tell if working properly or not
        let randomXVariation = Float.random(in: -3.0...3.0)
        let randomZVariation = Float.random(in: -3.0...3.0)

        if spawnLocation.x > 0 {
            modifierX = Double(-2 + randomXVariation)
        } else {
            modifierX = Double(2 + randomXVariation)
        }
        if spawnLocation.z > 0 {
            modifierZ = Double(-2 + randomZVariation)
        } else {
            modifierZ = Double(2 + randomZVariation)
        }
        
        self.position.x += Float(self.increment * modifierX)
        self.position.z += Float(self.increment * modifierZ)
        
        // Move food relative to the player
        if Globals.playerIsMoving {
            let translationVector = SCNVector3(Globals.rawInputX / 100, 0, Globals.rawInputZ / 100)
            
            self.position.x += translationVector.x
            self.position.z += translationVector.z
        }
    }
    
    func firstUpdate() async {
        await reanimate()
    }
    
    
    // Your 'Update()' function
    @MainActor
    func reanimate() async {
        // code logic here
        move()
        
        // Repeat increment 'reanimate()' every 1/60 of a second (60 frames per second)
        try! await Task.sleep(nanoseconds: UInt64(1.0 / 60.0))
        await reanimate()
    }
}
