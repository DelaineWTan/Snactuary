//
//  OrbitingProjectileAbility.swift
//  Pet Bullet Heaven
//
//  Created by Jay Wang on 2024-02-13.
//

import Foundation
import SceneKit

class OrbitingProjectileAbility : Ability {
    
    // Member Variables
    var _numProjectiles : Int?
    
    var _rotationSpeed : Float?
     
    var _distanceFromCenter : Float?
    
    var _Projectile : Projectile?
    
    var _ProjectileList : [Projectile] = []
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Mutated Constructor
    init(_InputAbilityDamage: Int, _InputAbilityDuration: Int, _InputRotationSpeed : Float, _InputDistanceFromCenter : Float, _InputNumProjectiles: Int){
        
        super.init()
        
        _AbilityDamage = _InputAbilityDamage
        _AbilityDuration = _InputAbilityDuration
        _rotationSpeed = _InputRotationSpeed
        _distanceFromCenter = _InputDistanceFromCenter
        _numProjectiles = _InputNumProjectiles
    }
    
    /*
     Helper Function for spawning the projectile, making sure that I've already set my Projectile.
     */
    override func SpawnProjectile() -> Projectile {
        
        var _SpawnedProjectile = OrbitingPaw(_InputDamage: 1)
        _ProjectileList.append(_SpawnedProjectile)
        
        // Add to the rootNode of this SceneGraph
        self.addChildNode(_SpawnedProjectile)
        
        return _SpawnedProjectile
    }
    
    /*
     Overriden Function for activating this ability. The majority of the effects will happen here.
     */
    override func ActivateAbility() -> Bool {
        
        // 1. Find the intervals at which I need to spawn projectiles
        var _Intervals = CalculateProjectileInterval()
        
        // 2. Initialize all the Projectiles
        while (_ProjectileList.count < _numProjectiles!){
            SpawnProjectile() // Throw if this returns null, something wrong happened
        }
        
        // 3. For each projectile, spawn them around Origin, with given _distanceFromCenter and rotate them to appropriate angles
        var _Counter = 0
        while _Counter < _ProjectileList.capacity-1 {
            
            // Translate them in the forward direction
            _ProjectileList[_Counter].localTranslate(by: SCNVector3(0,0,_distanceFromCenter!))
            
            // Rotate them along the Z-Axis accordingly.
            _ProjectileList[_Counter].eulerAngles = SCNVector3(0,0,_Intervals * Float(_Counter))
            
            _Counter+=1
        }
        
        return true
    }
    
    /*
     Takes into consideration, the number of projectiles I will need to spawn,
    then returns the the angle I need to rotate each interval for each Projectile I'm Spawning
     */
    func CalculateProjectileInterval() -> Float {
        return Float(360 / _numProjectiles!)
    }
    
    func SetSpawnedProjectile(_ProjetileStrategy: Projectile){
        _Projectile = _ProjetileStrategy
    }
    
}
