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
        _Mesh = loadFromFile(_AssetName: "Paw 4", _FileType: "dae") // Dummy Mesh
//        _Mesh = SCNNode(geometry: SCNBox(width: 2, height: 2, length: 2, chamferRadius: 0))
        
        self.addChildNode(_Mesh!)
        
    }
    
}
