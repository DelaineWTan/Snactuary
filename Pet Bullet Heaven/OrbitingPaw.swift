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
        //_Mesh = loadFromFile(_AssetName: "Penguin.001", _FileType: "dae") // Dummy Mesh
        _Mesh = SCNBox(width: 1,height: 1,length: 1,chamferRadius: 0)
        
    }
    
}
