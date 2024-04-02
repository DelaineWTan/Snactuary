//
//  Projectile.swift
//  Pet Bullet Heaven
//
//  Created by Jay Wang on 2024-02-13.
//

import Foundation
import SceneKit

class Projectile : SCNNode, MonoBehaviour {
    
    // TODO: NOTE TO SELF, REFACTOR THIS FILE
    
    var uniqueID: UUID
    
    func Start() {
        
    }
    
    func Update() {
        
        if Globals.playerIsMoving {
            let translationVector = SCNVector3(Float(Globals.inputX) * Globals.playerMovementSpeed * Float(Globals.deltaTime), 0, Float(Globals.inputZ) * Globals.playerMovementSpeed * Float(Globals.deltaTime))
            
            self.position.x += translationVector.x
            self.position.z += translationVector.z
        }
    }
    
    var onDestroy: (() -> Void)?
    
    override init() {
        self.uniqueID = UUID()
        _Launched = false
        super.init()
        LifecycleManager.Instance.addGameObject(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    // Member Variables
    var _Damage : Int = 1
    let playerCategory: Int = 0b001
    var _Mesh : SCNNode?
    
    var _Launched = false
    var _Destination : SCNVector3?
    var _ProjectileSpeed : Int?
    
    func OnCollision(){
        
    }
    
    func loadFromFile(_AssetName: String, _FileType: String) -> SCNReferenceNode {
        
        // Create a physics body
        let petPhysicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: SCNBox(width: 1.5, height: 5, length: 2.5, chamferRadius: 0.2), options: nil)) // Create a dynamic physics body
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
    
    func setDamage(_ damage:Int){
        _Damage = damage
    }
    
}
