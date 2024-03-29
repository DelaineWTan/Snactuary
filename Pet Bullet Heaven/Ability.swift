//
//  AbstractAbility.swift
//  Pet Bullet Heaven
//
//  Created by Jay Wang on 2024-02-13.
//

import Foundation
import SceneKit

class Ability : SCNNode {
    
    // Member Variables
    var _AbilityDuration : Double?
    
    var _Projectile : () -> Projectile
    
    init(withProjectile: @escaping () -> Projectile) {
        _Projectile = withProjectile
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func SpawnProjectile() {

    }
    
    func ActivateAbility() -> Bool { 
        return false
    }
    
}
