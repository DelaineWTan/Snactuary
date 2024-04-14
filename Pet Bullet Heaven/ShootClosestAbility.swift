//
//  ShootClosestAbility.swift
//  Pet Bullet Heaven
//
//  Created by Jay Wang on 2024-03-29.
//

import Foundation
import SceneKit

class ShootClosestAbility: Ability {
    // Member Variable
    var _Range : Float?
    var _FireRate : Double?
    var _ProjectileSpeed : Int?
    var _ProjectileDuration :Double?
    
    init(_InputRange: Float, _InputFireRate: Double, _InputProjectileSpeed: Int, _InputProjectileDuration: Double,_InputProjectile: @escaping ()->Projectile){
        
        super.init(withProjectile: _InputProjectile)
        // Assign the Member Variables
        _Range = _InputRange
        _FireRate = _InputFireRate
        _ProjectileSpeed = _InputProjectileSpeed
        _ProjectileDuration = _InputProjectileDuration
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shootProjectileAtDestination(_InputDestination: SCNVector3){
        
        // TODO: Spawn the Projectile
        let newProjectile = SpawnProjectile()
        newProjectile.setDamage(damage!)
        newProjectile._Destination = _InputDestination
        newProjectile._ProjectileSpeed = _ProjectileSpeed
        
        TerminateProjectile(_InputProjectile:  newProjectile)
        
        // Heavy assumption that this ability is attached to the Scene
        Globals.mainScene.rootNode.addChildNode(newProjectile)
    }
    
    override func activate() -> Bool {
        
        // TODO: Create a timer for the Fire Rate
        let timer = Timer(timeInterval: Double(_FireRate!), repeats: true){ [self]
            Timer in
            
            // Get the Closest FoodNode. Tuple containing the closest FoodNode, and the distance to it.
            let _ClosestFoodNodeTuple = LifecycleManager.Instance.getClosestFood()

            // Check for valid
            if (checkValidRange(_InputDistance: _ClosestFoodNodeTuple.1)){
                shootProjectileAtDestination(_InputDestination: _ClosestFoodNodeTuple.0!.position)
            }
        }
        
        // Add Timer
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
        
        // Dummy Return
        return true
        
    }
    
    /**
     Helper Function to check for valid range.
     */
    func checkValidRange(_InputDistance: Float) -> Bool{
        return _InputDistance < _Range! ? true : false
    }
    
    /**
     After duration amount of time, we should terminate the Projectile, using the given reference to Projectile.
     */
    func TerminateProjectile(_InputProjectile: Projectile){
        
        //        // TODO: Instantiate a SCNAction to wait duration amount of Time.
        //        let waitAction = SCNAction.wait(duration: _ProjectileDuration!)
        //
        //        // TODO: Execute the wait
        //        self.runAction(waitAction)
        //
        //        // TODO: Actually Terminate the Projectile here.
        //        _InputProjectile.removeFromParentNode()
        _InputProjectile.Destroy(after: _ProjectileDuration!)
    }
    
    override func copy() -> Any {
        let copy = ShootClosestAbility(_InputRange: self._Range ?? 0,
                                       _InputFireRate: self._FireRate ?? 0,
                                       _InputProjectileSpeed: self._ProjectileSpeed ?? 0,
                                       _InputProjectileDuration: self._ProjectileDuration ?? 0,
                                       _InputProjectile: self.createProjectile)
        
        return copy
    }
    
}
