//
//  Projectile.swift
//  Pet Bullet Heaven
//
//  Created by Jay Wang on 2024-02-13.
//

import Foundation
import SceneKit

class Projectile : SCNNode{
    
    // Member Variables
    var _Damage : Int = 1
    let playerCategory: Int = 0b001
    var _Mesh : SCNNode?
    
    func OnCollision(){
        
    }
    
    func loadFromFile(_AssetName: String, _FileType: String) -> SCNReferenceNode {
        
        // Create a physics body
        let petPhysicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: SCNBox(width: 0.7, height: 0.7, length: 0.7, chamferRadius: 0.2), options: nil)) // Create a dynamic physics body
        petPhysicsBody.mass = 1.0 // Set the mass of the physics body
        petPhysicsBody.isAffectedByGravity = false
        
        self.physicsBody = petPhysicsBody
        self.physicsBody?.categoryBitMask = playerCategory
        self.physicsBody?.collisionBitMask = -1
        self.physicsBody?.contactTestBitMask = 1
        
        // Retrieve the URL of the specified Resource
        let _URL = Bundle.main.url(forResource: _AssetName, withExtension: _FileType)
        
        // Load resource (referenced Scene file) as children of the ReferenceNode from the given URL
        let _ReferenceNode = SCNReferenceNode(url: _URL!)
        
        // Actually load the contents from the Referenced Node, into SCNReferenceNode
        _ReferenceNode?.load()
        
        _ReferenceNode?.name = _AssetName
        
        return _ReferenceNode!
        
    }
    
}
