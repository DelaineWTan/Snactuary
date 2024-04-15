//
//  LaunchedProjectile.swift
//  Pet Bullet Heaven
//
//  Created by Jay Wang on 2024-03-29.
//

import Foundation
import SceneKit

class LaunchedProjectile: Projectile {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func Update() {
        
        moveTowardsDestination()
        
        if Globals.playerIsMoving {
            let translationVector = SCNVector3(Float(Globals.inputX) * Globals.playerMovementSpeed * Float(Globals.deltaTime), 0, Float(Globals.inputZ) * Globals.playerMovementSpeed * Float(Globals.deltaTime))
            
            self.position.x += translationVector.x
            self.position.z += translationVector.z
            self._Destination!.x += translationVector.x
            self._Destination!.z += translationVector.z
        }
    }
    
    // Mutated Constructor
    override init(_InputDamage: Int, assetName: String){
        // Call to Super Constructor
        super.init(_InputDamage: _InputDamage, assetName: assetName)
        
        _Damage = _InputDamage
        _Mesh = loadFromFile(_AssetName: assetName, _FileType: "dae")
        self.position.y += 1
        //self.scale = SCNVector3(x: 0.5, y: 0.5, z: 0.5) // changing the scale does not change the hitbox
        self.addChildNode(_Mesh!)
        
    }
    
    func moveTowardsDestination() {
        let distance = Utilities.distanceBetween(vector1: self.position, vector2: self._Destination!)
        if (distance.rounded() > 0) {
            self.look(at: self._Destination!)
            
            // Calculate the direction vector from current position to destination
            let direction = SCNVector3(self._Destination!.x - self.position.x,
                                        self._Destination!.y - self.position.y,
                                        self._Destination!.z - self.position.z)

            // Normalize the direction vector
            let distance = sqrt(direction.x * direction.x + direction.y * direction.y + direction.z * direction.z)
            let normalizedDirection = SCNVector3(direction.x / distance, direction.y / distance, direction.z / distance)

            // Define the speed of movement (adjust as needed)
            let speed: Float = Float(_ProjectileSpeed!)

            // Move towards the destination by interpolating between current position and destination
            // Calculate the amount to move along each axis
            let deltaX = normalizedDirection.x * speed * Float(Globals.deltaTime)
            let deltaY = normalizedDirection.y * speed * Float(Globals.deltaTime)
            let deltaZ = normalizedDirection.z * speed * Float(Globals.deltaTime)

            // Calculate the new position
            let newPositionX = self.position.x + deltaX
            let newPositionY = self.position.y + deltaY
            let newPositionZ = self.position.z + deltaZ

            // Update the position
            self.position = SCNVector3(newPositionX, newPositionY, newPositionZ)
//            localTranslate(by: SCNVector3(0,0, -Float(_ProjectileSpeed!) * Float(Globals.deltaTime)))
        } else {
            self.Destroy(after: 0)
        }
    }
}
