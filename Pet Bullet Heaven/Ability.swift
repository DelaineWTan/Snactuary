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
    var _AbilityDamage : Int?
    
    var _AbilityDuration : Int?
    
    func SpawnProjectile() -> Projectile {
        return Projectile()
    }
    
    func ActivateAbility() -> Bool { 
        return false
    }
    
}
