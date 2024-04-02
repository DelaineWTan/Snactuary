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
    
    override func Update() {
        
        if (_Launched){
            moveTowardsDestination()
        }
        
        if Globals.playerIsMoving {
            let translationVector = SCNVector3(Float(Globals.inputX) * Globals.playerMovementSpeed * Float(Globals.deltaTime), 0, Float(Globals.inputZ) * Globals.playerMovementSpeed * Float(Globals.deltaTime))
            
            self.position.x += translationVector.x
            self.position.z += translationVector.z
            self._Destination!.x += translationVector.x
            self._Destination!.z += translationVector.z
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
    
    func moveTowardsDestination(){
        let distance = Utilities.distanceBetween(vector1: self.position, vector2: self._Destination!)
        print(distance.rounded())
        if (distance.rounded() > 0) {
            self.look(at: self._Destination!)
            
//            self.position.x +=
            localTranslate(by: SCNVector3(0,0, -Float(_ProjectileSpeed!) * Float(Globals.deltaTime)))
        } else {
            print("reached dest, destroying")
            self.onDestroy(after: 0)
        }
    }
}
