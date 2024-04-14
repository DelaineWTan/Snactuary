//
//  AbstractAbility.swift
//  Pet Bullet Heaven
//
//  Created by Jay Wang on 2024-02-13.
//

import Foundation
import SceneKit

class Ability : SCNNode {
    // Member Variables
    var damage : Int?
    var isActive : Bool = false
    var duration : Double?
    var timer : Timer?
    
    var activeProjectiles : [Projectile] = []
    var createProjectile : () -> Projectile
    
    // Parent Node is the Scene, so we'll be able to find the Player.
    var playerNode : SCNNode?
    
    init(withProjectile: @escaping () -> Projectile) {
        createProjectile = withProjectile
        damage = 1
        duration = 0.0
        isActive = false
        super.init()
        
        playerNode = Globals.mainScene.rootNode.childNode(withName: "mainPlayer", recursively: true)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDamage(_ damage:Int) {
        self.damage = damage
        
        for projectile in activeProjectiles {
            projectile.setDamage(damage)
        }
    }
    
    func SpawnProjectile() -> Projectile {
        let newProjectile = createProjectile()
        activeProjectiles.append(newProjectile)
        
        // Add to SceneGraph as child of this ability
        self.addChildNode(newProjectile)
        return newProjectile
    }
    
    func DespawnProjectile(activeProjectile: Projectile) {
        // Find the index of the activeProjectile in the activeProjectiles array
        if let index = activeProjectiles.firstIndex(where: { $0.uniqueID == activeProjectile.uniqueID }) {
            // Remove the projectile from the activeProjectiles array
            activeProjectiles.remove(at: index)
            // Call Monobehaviour Destroy to destroy immediately
            activeProjectile.Destroy()
        } else {
            print("Projectile not found in active projectiles, despawn failed")
        }
    }
    
    func activate() -> Bool {
        return false
    }
    
    func deactivate() {
        timer?.invalidate()
        timer = nil
    }
}
