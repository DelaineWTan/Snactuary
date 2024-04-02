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
    var _SpawnRate : Double?
    
    // The Range with which to limit spawning the projectiles.
    var _Range : Float?
    
    // The amount of time that spawned Projectiles lasts for.
    var _ProjectileDuration: Double?
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Mutated Constructor
    init(_InputSpawnRate: Double, _InputRange: Float, _InputProjectileDuration: Double, _InputProjectile: @escaping () -> Projectile){
        super.init(withProjectile: _InputProjectile)
        
        // Assign the Member Variables
        _SpawnRate = _InputSpawnRate
        _Range = _InputRange
        _ProjectileDuration = _InputProjectileDuration
    }
    
    /**
     Helper function to spawn projectiles. Howeve, we necessarily override for the  implementation of this ability because the Projectiles positions are do not need to be with respect with the Player's position.
     Additionally, we need to terminate the projectiles individually after as well.
     */
    override func SpawnProjectile() {
        
        // TODO: Generate a valid vector along the X,Z Plane
        let _ProjectilePosition = generateRandomPositionInRange()
        
        // TODO: Instantiate Projectile.
        let _SpawnedProjectile = createProjectile()
        _SpawnedProjectile.setDamage(damage!)
        
        projectiles.append(_SpawnedProjectile)
        projectiles[0].position = _ProjectilePosition
        
        // TODO: Attach Projectile to Scene, not the Ability.
        playerNode?.parent?.addChildNode(projectiles[0])
        
        // TODO: Terminate the Projectile after given amount of duration
        TerminateProjectile(_InputProjectile: projectiles[0])
        projectiles.removeAll()
        
    }
    
    /**
     Overriden Function for Activiating this ability.
     */
    override func ActivateAbility() -> Bool {
        
        // TODO: Spawn the Projectile
        let timer = Timer(timeInterval: _SpawnRate!, repeats: true) { Timer in
            self.SpawnProjectile()
        }
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
        
        // Dummy Return
        return true
    }
    
    /**
     Helper Function for approving that the given generated position is valid. Returns Validity
     */
    func checkValidPosition(_InputVector3: SCNVector3) -> Bool {
        
        // TODO: Calculate the Magnitude of the Difference Vector between the current Position and the Chosen Vector against the given Range with which we should limit our spawning.
        
        // Check the X Range
        let inXRange = (_InputVector3.x <= (playerNode?.position.x)! + _Range! && _InputVector3.x >= (playerNode?.position.x)! - _Range!)
        
        // Check the Z Range
        let inZRange = (_InputVector3.z <= (playerNode?.position.z)! + _Range! && _InputVector3.z >= (playerNode?.position.z)! - _Range!)
        
        return (inXRange && inZRange)
    }
    
    /**
     Helper Function for generating a valid position  along the X,Z Plane./
     */
    func generateRandomPositionInRange() -> SCNVector3 {
        // TODO: Generate a Vector
        var _GeneratedPosition = randomVectorInRange(_CurrentPosition: playerNode!.position)
        
        // TODO: Check vector for Validity, keep generating until I have a Valid Position
        while (!checkValidPosition(_InputVector3: _GeneratedPosition)){
            
            _GeneratedPosition = randomVectorInRange(_CurrentPosition: playerNode!.position)
            
        }
        
        // Finally Return Generated Position
        return _GeneratedPosition
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
        
        _InputProjectile.onDestroy(after: _ProjectileDuration!)
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
    
    override func copy() -> Any {
        let copy = SpawnProjectileInRangeAbility(
            _InputSpawnRate: self._SpawnRate ?? 0,
            _InputRange: self._Range ?? 0,
            _InputProjectileDuration: self._ProjectileDuration ?? 0,
            _InputProjectile: self.createProjectile)
        // Copy additional properties if needed
        return copy
    }
}
