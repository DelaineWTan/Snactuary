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
    var attack: Int = 1
    var speed: Float = 1
    var exp: Int
    //exp needed to level up
    var levelUpExp: Int = 1
    var petLevel: Int = 1
    var unlocked: Bool
    
    
    // might need more properties yea, add more if you see fit DO NOT CHANGE THE EXISTING ONES and update the constructor and Globals define pets as well thx :DDDDDD
    
    var attackGrowth: Float
    var speedGrowth: Float
    var expGrowth: Float // for control over gradually raising exp cap for levels
    
    init(petName: String, petId: Int, petImageName: String = "art.scnassets/locked.png", petModelName: String = "art.scnassets/Paw 4.scn", attack: Int = 1, attackGrowth: Float = 2.0, speedGrowth: Float = 2.0, expGrowth: Float = 2.0, attackPattern: Ability = OrbitingProjectileAbility(_InputAbilityDamage: 1, _InputAbilityDuration: 10, _InputRotationSpeed: 15, _InputDistanceFromCenter: 10, _InputNumProjectiles: 5, _InputProjectile: { ()->Projectile in OrbitingPaw(_InputDamage: 1)}), unlockedInput: Bool = true, currentExp: Int = 0, level: Int = 1) {
        id = petId
        imageName = petImageName
        modelName = petModelName
        exp = currentExp
        levelUpExp = 5
        petLevel = level
        self.attack = attack
        self.attackPattern = attackPattern
        self.unlocked = unlockedInput
        self.attackGrowth = attackGrowth
        self.speedGrowth = speedGrowth
        self.expGrowth = expGrowth
        
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
