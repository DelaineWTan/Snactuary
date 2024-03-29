//
//  OrbitingPaw.swift
//  Pet Bullet Heaven
//
//  Created by Jay Wang on 2024-02-13.
//

import Foundation
import SceneKit

class OrbitingPaw : Projectile {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
}
