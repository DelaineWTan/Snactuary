//
//  LaunchedProjectile.swift
//  Pet Bullet Heaven
//
//  Created by Jay Wang on 2024-03-29.
//

import Foundation
import SceneKit

class LaunchedProjectile: Projectile {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func Update(deltaTime: TimeInterval) {
        
        if (_Launched){
            moveTowardsDestination(deltaTime: deltaTime)
        }
        
        if Globals.playerIsMoving {
            let translationVector = SCNVector3(Float(Globals.inputX) * Globals.playerMovementSpeed * Float(deltaTime), 0, Float(Globals.inputZ) * Globals.playerMovementSpeed * Float(deltaTime))
            
            self.position.x += translationVector.x
            self.position.z += translationVector.z
        }
    }
    
    // Mutated Constructor
    init(_InputDamage: Int){
        // Call to Super Constructor
        super.init()
        
        _Damage = _InputDamage
        _Mesh = loadFromFile(_AssetName: "Paw 4", _FileType: "dae")
        self.position.y += 1
        //self.scale = SCNVector3(x: 0.5, y: 0.5, z: 0.5) // changing the scale does not change the hitbox
        self.addChildNode(_Mesh!)
        
    }
    
    func moveTowardsDestination(deltaTime: TimeInterval){
        self.look(at: self._Destination!)
        
        localTranslate(by: SCNVector3(0,0, -Float(_ProjectileSpeed!) * Float(deltaTime)))
        
    }
    
}
