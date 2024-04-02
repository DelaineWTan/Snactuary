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
    var _AbilityDamage : Int?
    var _AbilityActivated : Bool = false
    var _AbilityDuration : Double?
    
    var _ProjectileList : [Projectile] = []
    
    var _Projectile : () -> Projectile
    
    // Parent Node is the Scene, so we'll be able to find the Player.
    var playerNode : SCNNode?
    
    init(withProjectile: @escaping () -> Projectile) {
        _Projectile = withProjectile
        _AbilityDamage = 1
        _AbilityDuration = 0.0
        _AbilityActivated = false
        super.init()
        
        playerNode = Globals.mainScene.rootNode.childNode(withName: "mainPlayer", recursively: true)
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDamage(_ damage:Int){
        _AbilityDamage = damage
        
        for projectile in _ProjectileList {
            projectile.setDamage(damage)
        }
    }
    
    func SpawnProjectile() {

    }
    
    func ActivateAbility() -> Bool { 
        return false
    }
    
}
