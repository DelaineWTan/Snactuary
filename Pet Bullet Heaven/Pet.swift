//
//  Pet.swift
//  Pet Bullet Heaven
//
//  Created by Jasper Zhou on 2024-02-13.
//

import SceneKit

public class Pet : SCNNode{
    let id: Int
    var imageName: String
    var modelName: String // name of the .scn file of the 3D model for the pet
    var attackPattern: Ability
    var baseAttack: Float = 1
    var speed: Float = 1
    var exp: Float
    //exp needed to level up
    var levelUpExp: Float = 1.0
    var petLevel: Int = 1
    var unlocked: Bool
    // slot position in scene
    var slotPosition = SCNVector3(0,0,0)
    
    // might need more properties yea, add more if you see fit DO NOT CHANGE THE EXISTING ONES and update the constructor and Globals define pets as well thx :DDDDDD
    
    var healthGrowth = 1
    var attackGrowth = 1
    var speedGrowth = 1
    
    init(petName: String, petId: Int, petImageName: String = "art.scnassets/locked.png", petModelName: String = "art.scnassets/Paw 4.scn", attack: Float = 1, attackPattern: Ability = OrbitingProjectileAbility(_InputAbilityDamage: 1, _InputAbilityDuration: 10, _InputRotationSpeed: 15, _InputDistanceFromCenter: 10, _InputNumProjectiles: 5, _InputProjectile: { ()->Projectile in OrbitingPaw(_InputDamage: 1)}), unlockedInput: Bool = true, currentExp: Float = 0, level: Int = 1) {
        id = petId
        imageName = petImageName
        modelName = petModelName
        exp = currentExp
        levelUpExp = 15
        petLevel = level
        baseAttack = attack
        self.attackPattern = attackPattern
        self.unlocked = unlockedInput
        
        super.init()
        name = petName
        // Create a physics body
        let petPhysicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: SCNBox(width: 1.5, height: 5, length: 2.5, chamferRadius: 0.2), options: nil)) // Create a dynamic physics body
        petPhysicsBody.mass = 1.0 // Set the mass of the physics body
        petPhysicsBody.isAffectedByGravity = false
        
        let playerCategory: Int = 0b001
        self.physicsBody = petPhysicsBody
        self.physicsBody?.categoryBitMask = playerCategory
        self.physicsBody?.collisionBitMask = -1
        self.physicsBody?.contactTestBitMask = 1
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func levelUpCheck() -> Bool{
        return exp >= levelUpExp
            
    }
    
}
