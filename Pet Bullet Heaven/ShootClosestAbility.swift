//
//  ShootClosestAbility.swift
//  Pet Bullet Heaven
//
//  Created by Jay Wang on 2024-03-29.
//

import Foundation
import SceneKit

class ShootClosestAbility: Ability, MonoBehaviour {
    var uniqueID: UUID
    
    func Start() {
        
    }
    
    func Update(deltaTime: TimeInterval) {
        
    }
    
    var onDestroy: (() -> Void)?
    
    
    // Member Variable
    var _Range : Float?
    var _FireRate : Int?
    var _ProjectileSpeed : Int?
    
    init(_InputRange: Float, _InputFireRate: Int, _InputProjectileSpeed: Int,_InputProjectile: @escaping ()->Projectile){
        
        self.uniqueID = UUID()
        super.init(withProjectile: _InputProjectile)
        
        // Assign the Member Variables
        _Range = _InputRange
        _FireRate = _InputFireRate
        _ProjectileSpeed = _InputProjectileSpeed
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func SpawnAndReturnProjectile()-> Projectile{
        return _Projectile()
    }
    
    override func ActivateAbility() -> Bool {
        
        // Get the Closest FoodNode. Tuple containing the closest FoodNode, and the distance to it.
        let _ClosestFoodNodeTuple = LifecycleManager.Instance.getClosestFood()
        
        // TODO: Create a timer for the Fire Rate
        let timer = Timer(timeInterval: Double(_FireRate!), repeats: true){ [self]
            Timer in
            
            // Check for valid
            if (checkValidRange(_InputDistance: _ClosestFoodNodeTuple.1)){
                LaunchProjectile()
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
    
    func LaunchProjectile(){
        
        // TODO: Spawn the Projectile
        let _SpawnedProjectile = SpawnAndReturnProjectile()
        
    }
}
