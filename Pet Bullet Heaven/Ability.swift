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
    var _AbilityActivated : Bool = false
    var _AbilityDuration : Double?
    
    var _Projectile : () -> Projectile
    
    init(withProjectile: @escaping () -> Projectile) {
        _Projectile = withProjectile
        _AbilityDamage = 0
        _AbilityDuration = 0.0
        _AbilityActivated = false
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
