//
//  AbstractAbility.swift
//  Pet Bullet Heaven
//
//  Created by Jay Wang on 2024-02-13.
//

import Foundation
import SceneKit

class Ability : SCNNode {
    var _AbilityActivated : Bool = false
    
    // Member Variables
    var _AbilityDamage : Int?
    
    var _AbilityDuration : Double?
    
    func SpawnProjectile() -> Projectile {
        return Projectile()
    }
    
    func ActivateAbility() -> Bool { 
        return false
    }
    
}
