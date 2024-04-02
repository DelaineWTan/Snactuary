//
//  Pet.swift
//  Pet Bullet Heaven
//
//  Created by Jasper Zhou on 2024-02-13.
//

public class Pet {
    let id: Int
    var name: String
    var imageName: String
    var modelName: String // name of the .scn file of the 3D model for the pet
    var attackPattern: Ability
    var baseAttack: Float = 1
    var speed: Float = 1
    var currentExp: Float
    //exp needed to level up
    var levelUpExp: Float = 1.0
    var level: Float = 1
    var unlocked: Bool
    
    // might need more properties yea, add more if you see fit DO NOT CHANGE THE EXISTING ONES and update the constructor and Globals define pets as well thx :DDDDDD
    
    init(petName: String, petId: Int, petImageName: String = "art.scnassets/locked.png", petModelName: String = "art.scnassets/Paw 4.scn", attack: Float = 1, attackPattern: Ability = OrbitingProjectileAbility(_InputAbilityDamage: 1, _InputAbilityDuration: 10, _InputRotationSpeed: 15, _InputDistanceFromCenter: 10, _InputNumProjectiles: 5, _InputProjectile: { ()->Projectile in OrbitingPaw(_InputDamage: 1)}), unlockedInput: Bool = true) {
        id = petId
        name = petName
        imageName = petImageName
        modelName = petModelName
        currentExp = 0
        levelUpExp = 1
        baseAttack = attack
        self.attackPattern = attackPattern
        self.unlocked = unlockedInput
    }
    
    func levelUpCheck() -> Bool{
        return currentExp >= levelUpExp
            
        }
    
    func getAttack() -> Float{
        return baseAttack * level
    }
    
    
    
}
