//
//  SpawnProjectileInRangeAbility.swift
//  Pet Bullet Heaven
//
//  Created by Jay Wang on 2024-03-28.
//

import Foundation
import SceneKit

class SpawnProjectileInRangeAbility : Ability {
    
    // Member Variables
    // The rate at which to spawn projectils (measured in Seconds)
    var _SpawnRate : Int?
    // The Range with which to limit spawning the projectiles.
    var _Range : Float?
    
    var _Projectile : Projectile?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Mutated Constructor
    init(_InputSpawnRate: Int, _InputRange: Float, _InputProjectile: Projectile){
        
        super.init()
        
        // Assign the Member Variables
        _SpawnRate = _InputSpawnRate
        _Range = _InputRange
        _Projectile = _InputProjectile
        
    }
    
    /**
     Overridden helper function to spawn the given projectile(s)
     */
    override func SpawnProjectile() -> Projectile {
        <#code#>
    }
    
    /**
     Overriden Function for Activiating this ability.
     */
    override func ActivateAbility() -> Bool {
        <#code#>
    }
    
    
    
}
