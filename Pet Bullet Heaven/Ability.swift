//
//  AbstractAbility.swift
//  Pet Bullet Heaven
//
//  Created by Jay Wang on 2024-02-13.
//

import Foundation

class Ability {
    
    // Member Variables
    var _AbilityDamage : Int = 1
    
    var _AbilityDuration : Int = 1
    
    func SpawnProjectile() -> Projectile {
        return Projectile()
    }
    
    func ActivateAbility() -> Bool{
        return false
    }
    
}
