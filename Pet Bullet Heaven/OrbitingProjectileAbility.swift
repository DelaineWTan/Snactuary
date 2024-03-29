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
    
    var _rotationSpeed : CGFloat?
     
    var _distanceFromCenter : Float?
    
    var _ProjectileList : [Projectile] = []
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Mutated Constructor
    init(_InputAbilityDamage: Int, _InputAbilityDuration: Double, _InputRotationSpeed : CGFloat, _InputDistanceFromCenter : Float, _InputNumProjectiles: Int, _InputProjectile: @escaping () -> Projectile){
        
        super.init(withProjectile: _InputProjectile)
        
        _AbilityDamage = _InputAbilityDamage
        _AbilityDuration = _InputAbilityDuration
        _rotationSpeed = _InputRotationSpeed
        _distanceFromCenter = _InputDistanceFromCenter
        _numProjectiles = _InputNumProjectiles
//        _Projectile = _InputProjectile
    }
    
    /*
     Helper Function for spawning the projectile, making sure that I've already set my Projectile.
     */
    override func SpawnProjectile() -> Projectile {
        
        // Deep Copy the Projectile
        let _SpawnedProjectile = _Projectile()
        print(_SpawnedProjectile)
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
        let _Intervals = CalculateProjectileInterval()
        
        // 2. Initialize all the Projectiles
        while (_ProjectileList.count < _numProjectiles!){
            _ = SpawnProjectile() // Throw if this returns null, something wrong happened
        }
        
        // 3. For each projectile, spawn them around Origin, with given _distanceFromCenter and rotate them to appropriate angles
        var _Counter = 0
        while _Counter < _ProjectileList.count{
            
            // Translate them in the forward direction
            _ProjectileList[_Counter].localTranslate(by: SCNVector3(0,0,_distanceFromCenter!))
            
            // Rotate them along the Z-Axis accordingly.
            _ProjectileList[_Counter].rotate(by: SCNQuaternion(x:0 ,y: sin((_Intervals*Float(_Counter))/2), z:0 , w: cos((_Intervals*Float(_Counter))/2)), aroundTarget: SCNVector3(0,0,0))
            
            _Counter+=1
        }
        
        // Start rotating this Ability infinitely
        let rotationAction = SCNAction.rotateBy(x: 0, y: _rotationSpeed!, z: 0, duration: _AbilityDuration!)
        let repeatForeverAction = SCNAction.repeatForever(rotationAction)
        self.runAction(repeatForeverAction)
        
        return true
    }
    
    /*
     Takes into consideration, the number of projectiles I will need to spawn,
     then returns the the angle I need to rotate each interval for each Projectile I'm Spawning
     Returns radians
     */
    func CalculateProjectileInterval() -> Float {
//        return Float(360 / _numProjectiles!) / Float(Float.pi/180)
        return Float(360 / _numProjectiles!) * Float(Float.pi/180)
    }
    
//    func SetSpawnedProjectile(_ProjectileStrategy: Projectile){
//        _Projectile = _ProjectileStrategy
//    }
    
    func ConvertDegreesToRadian(_InDegrees: CGFloat) -> CGFloat {
        return CGFloat(_InDegrees * CGFloat(Float.pi / 180))
    }
    
}
