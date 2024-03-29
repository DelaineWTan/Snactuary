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
    //var baseAttack: Float
    //var speed: Float
    // var exp: Float
    // var currentExp
    
    // might need more properties yea, add more if you see fit DO NOT CHANGE THE EXISTING ONES and update the constructor and Globals define pets as well thx :DDDDDD
    
//    func Float getAttack {
//        return baseAttack * lvl
//    }
    
    init(petName: String, petId: Int, petImageName: String = "art.scnassets/locked.png", petModelName: String = "art.scnassets/Paw 4.scn", attackPattern: Ability = OrbitingProjectileAbility(_InputAbilityDamage: 1, _InputAbilityDuration: 10, _InputRotationSpeed: 15, _InputDistanceFromCenter: 10, _InputNumProjectiles: 5)) {
        id = petId
        name = petName
        imageName = petImageName
        modelName = petModelName
        self.attackPattern = attackPattern
    }
}
