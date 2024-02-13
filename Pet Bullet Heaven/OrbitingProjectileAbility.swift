//
//  OrbitingProjectileAbility.swift
//  Pet Bullet Heaven
//
//  Created by Jay Wang on 2024-02-13.
//

import Foundation

class OrbitingProjectileAbility : Ability {
    
    // Member Variables
    var _numProjectiles : Int?
    
    var _rotationSpeed : Float?
     
    var _distanceFromCenter : Float?
    
    var _Projectile : Projectile?
    
    var _ProjectileList : [Projectile]?
    
    // Mutated Constructor
    func OrbitingProjectileAbility(_InputAbilityDamage: Int, _InputAbilityDuration: Int, _InputRotationSpeed : Float, _InputDistanceFromCenter : Float){
        _AbilityDamage = _InputAbilityDamage
        _AbilityDuration = _InputAbilityDuration
        _rotationSpeed = _InputRotationSpeed
        _distanceFromCenter = _InputDistanceFromCenter
    }
    
    /*
     Helper Function for spawning the projectile, making sure that I've already set my Projectile.
     */
    override func SpawnProjectile() -> Projectile {
        <#code#>
    }
    
    /*
     Overriden Function for activating this ability. The majority of the effects will happen here.
     */
    override func ActivateAbility() -> Bool {
        <#code#>
    }
    
    /*
     Takes into consideration, the number of projectiles I will need to spawn,
    then returns the the angle I need to rotate each interval for each Projectile I'm Spawning
     */
    func CalculateProjectileInterval(){
         
    }
    
    func SetSpawnedProjectile(_ProjetileStrategy: Projectile){
        _Projectile = _ProjetileStrategy
    }
    
}
