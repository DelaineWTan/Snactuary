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
    
    var projectiles : [Projectile] = []
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
    
    func setDamage(_ damage:Int){
        self.damage = damage
        
        for projectile in projectiles {
            projectile.setDamage(damage)
        }
    }
    
    func SpawnProjectile() {

    }
    
    func ActivateAbility() -> Bool { 
        return false
    }
    
}
