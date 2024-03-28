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
    
    // The amount of time that spawned Projectiles lasts for.
    var _ProjectileDuration: Int?
    
    // The respective Projectile that we're going to be spawning
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
        
        // TODO: Generate a valid vector along the X,Z Plane
        
        // TODO: Spawn the Projectile
        
        // TODO: Wait for duration amount of time
        
        // TODO: Terminate the Projectile after given amount of duration
        // TerminateProjectile(Projectile)
        
    }
    
    /**
     Helper Function for generating a valid position  along the X,Z Plane./
     */
    func generateRandomPositionInRange() -> SCNVector3 {
        
        // TODO: Generate a Vector
        
        // TODO: Check vector for Validity
        
    }
    
    /**
     Helper Function for approving that the given generated position is valid. Returns Validity
     */
    func checkValidPosition(_InputVector3: SCNVector3) -> Bool {
        
        // TODO: Calculate the Magnitude of the Difference Vector between the current Position and the Chosen Vector against the given Range with which we should limit our spawning.
        
        
        
        // Dummy Return
        return false
    }
    
    /**
     After duration amount of time, we should terminate the Projectile, using the given reference to Projectile.
     */
    func terminateProjectile(_InputProjectile: Projectile){
        
        // TODO: Instantiate a SCNAction to wait duration amount of Time.
        
        // TODO: Execute the wait
        
        // TODO: Actually Terminate the Projectile here.
        
    }
    
    
}
