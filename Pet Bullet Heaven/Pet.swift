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
    // base stats and ability (when pet is level 1)
    var baseAbility: Ability
    var baseAttack: Int = 1
    var baseSpeed: Float = 1
    var baseExp: Int = 10
    //exp needed to level up
    var levelUpExp: Int = 1
    var level: Int = 1
    var unlocked: Bool
    // stats affected by level ups
    var activeAbility: Ability
    var attack: Int = 1
    var speed: Float = 1
    var exp: Int = 0
    // slot position in scene
    var slotPosition = SCNVector3(0,0,0)
    
    // might need more properties yea, add more if you see fit DO NOT CHANGE THE EXISTING ONES and update the constructor and Globals define pets as well thx :DDDDDD
    
    var attackGrowth: Float
    var speedGrowth: Float
    var expGrowth: Float // for control over gradually raising exp cap for levels
    
    init(petName: String, petId: Int, petImageName: String = "art.scnassets/locked.png", petModelName: String = "art.scnassets/Paw 4.scn", attack: Int = 1, attackGrowth: Float = 2.0, speedGrowth: Float = 0.1, expGrowth: Float = 5.0, baseAbility: Ability = OrbitingProjectileAbility(_InputAbilityDamage: 1, _InputAbilityDuration: 10, _InputRotationSpeed: 15, _InputDistanceFromCenter: 10, _InputNumProjectiles: 5, _InputProjectile: { ()->Projectile in OrbitingPaw(_InputDamage: 1)}), unlockedInput: Bool = true, currentExp: Int = 0, level: Int = 1) {
        id = petId
        imageName = petImageName
        modelName = petModelName
        levelUpExp = 5
        self.level = level
        self.attack = attack
        self.baseAbility = baseAbility
        self.unlocked = unlockedInput
        self.attackGrowth = attackGrowth
        self.speedGrowth = speedGrowth
        self.expGrowth = expGrowth
        self.activeAbility = baseAbility.copy() as! Ability
        super.init()
        // Level the pet up, update stats accordingly and set current exp
        self.levelUp(self.level)
        self.exp = currentExp
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
    
    func hasLeveledUp() -> Bool{
        return exp >= levelUpExp
        
    }
    
    // Levels up the pet and updates its stats to the given level
    func levelUp(_ level: Int) {
        self.level = level
        // no carryover exp for now for simplicity
        self.exp = 0
        // exp needed to level up is base exp * level
        self.levelUpExp = self.baseExp + Int(Float(self.level) * self.expGrowth)
        // attack increases by level * attackGrowth
        self.attack = self.baseAttack + Int(Float(self.level - 1) * attackGrowth)
        self.activeAbility.setDamage(Int(self.attack))
        // speed increases by level * speedGrowth
        self.speed = self.baseSpeed + Float(self.level - 1) * speedGrowth
    }
    
    // Activates the pet by enabling its ability
    func activate() {
        self.activeAbility = baseAbility.copy() as! Ability
        self.activeAbility.activate()
    }
}
