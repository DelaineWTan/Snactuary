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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Mutated Constructor
    init(_InputSpawnRate: Int, _InputRange: Float, _InputProjectile: @escaping () -> Projectile){
        
        super.init(withProjectile: _InputProjectile)
        
        // Assign the Member Variables
        _SpawnRate = _InputSpawnRate
        _Range = _InputRange
//        _Projectile = _InputProjectile
        
    }
    
    /**
     Helper function to spawn projectiles. Howeve, we necessarily override for the  implementation of this ability because the Projectiles positions are do not need to be with respect with the Player's position.
     Additionally, we need to terminate the projectiles individually after as well.
     */
    override func SpawnProjectile() -> Projectile{
        
        // TODO: Instantiate Projectile and attach to Scene, not the Ability.
        let _SpawnedProjectile = _Projectile()
        self.parent?.addChildNode(_SpawnedProjectile)
        
        // TODO: Wait for duration amount of time
        
        // TODO: Terminate the Projectile after given amount of duration
        // TerminateProjectile(Projectile)
        
        return _SpawnedProjectile
        
    }
    
    /**
     Overriden Function for Activiating this ability.
     */
    override func ActivateAbility() -> Bool {
        
        // TODO: Generate a valid vector along the X,Z Plane
        var _ProjectilePosition = generateRandomPositionInRange()
        
        // TODO: Spawn the Projectile
        SpawnProjectile()
        
        // Dummy Return
        return false
    }
    
    /**
     Helper Function for approving that the given generated position is valid. Returns Validity
     */
    func checkValidPosition(_InputVector3: SCNVector3) -> Bool {
        
        // TODO: Calculate the Magnitude of the Difference Vector between the current Position and the Chosen Vector against the given Range with which we should limit our spawning.
        
        // Check the X Range
        var inXRange = (_InputVector3.x <= self.position.x + _Range! && _InputVector3.x >= self.position.x - _Range!)
        
        // Check the Z Range
        var inZRange = (_InputVector3.z <= self.position.z + _Range! && _InputVector3.z >= self.position.z - _Range!)
        
        return (inXRange && inZRange)
    }
    
    /**
     Helper Function for generating a valid position  along the X,Z Plane./
     */
    func generateRandomPositionInRange() -> SCNVector3 {
        
        // TODO: Generate a Vector
        var _GeneratedPosition = randomVectorInRange(_CurrentPosition: self.position)
        
        // TODO: Check vector for Validity, keep generating until I have a Valid Position
        while (!checkValidPosition(_InputVector3: _GeneratedPosition)){
         
            _GeneratedPosition = randomVectorInRange(_CurrentPosition: self.position)
         
         }
        
        // Finally Return Generated Position
        return _GeneratedPosition
    }
    
    /**
     After duration amount of time, we should terminate the Projectile, using the given reference to Projectile.
     */
    func TerminateProjectile(_InputProjectile: Projectile){
        
        // TODO: Instantiate a SCNAction to wait duration amount of Time.
        
        // TODO: Execute the wait
        
        // TODO: Actually Terminate the Projectile here.
        
    }
    
    /**
     Helper Function to generate random X,Z values with respect to the current position
     */
    func randomVectorInRange(_CurrentPosition: SCNVector3) -> SCNVector3{
        
        // Generate new X and Z Values
        let newX = Float.random(in: _CurrentPosition.x-_Range!..<_CurrentPosition.x+_Range!)
        let newZ = Float.random(in: _CurrentPosition.z-_Range!..<_CurrentPosition.z+_Range!)
        
        // Return the new values
        return SCNVector3(newX,0,newZ)
    }
    
}
