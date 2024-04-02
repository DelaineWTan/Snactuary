//
//  Constants.swift
//  Pet Bullet Heaven
//
//  Created by Delaine on 2024-02-07.
//
import UIKit
import SwiftUI
import Combine
import SceneKit

public class Globals {
    // This version number is used to ensure local environments have the latest configured user data
    public static var userDataVersion = 1
    
    public static var mainScene = SCNScene(named: "art.scnassets/main.scn")!
    
    public static var pets: [Pet] = [
        Pet(petName:"Vin",
            petId: 1,
            petImageName: "frog1.png",
            petModelName: "art.scnassets/Frog.Green.scn",
            attack: 2,
            attackPattern: ShootClosestAbility(_InputRange: 100, _InputFireRate: 3, _InputProjectileSpeed: 20, _InputProjectileDuration: 3, _InputProjectile: {()->Projectile in LaunchedProjectile(_InputDamage: 1)})),
        
        Pet(petName:"Pengwin",
            petId: 2,
            petImageName: "penguin1.png",
            petModelName: "art.scnassets/Penguin.001.scn",
            attack: 3,
            attackPattern: OrbitingProjectileAbility(
                _InputAbilityDamage: 1,
                _InputAbilityDuration: 10,
                _InputRotationSpeed: 10,
                _InputDistanceFromCenter: 10,
                _InputNumProjectiles: 5,
                _InputProjectile: { ()->Projectile in OrbitingPaw(_InputDamage: 1)})),
        Pet(petName:"Pink Katt",
            petId: 3,
            petImageName: "cat2.png",
            petModelName: "art.scnassets/Cat.Pink.scn",
            attackPattern: OrbitingProjectileAbility(
                _InputAbilityDamage: 1,
                _InputAbilityDuration: 10,
                _InputRotationSpeed: 15,
                _InputDistanceFromCenter: 12.5,
                _InputNumProjectiles: 5,
                _InputProjectile: { ()->Projectile in OrbitingPaw(_InputDamage: 1)})),
        
        Pet(petName:"Dol Ducker",
            petId: 4,
            petImageName: "duck1.png",
            petModelName: "art.scnassets/Duck.Dolan.scn",
            attackPattern: SpawnProjectileInRangeAbility(_InputSpawnRate: 3, _InputRange: 12.0, _InputProjectileDuration: 3, _InputProjectile: { ()->Projectile in StationaryBomb(_InputDamage: 1)})),
        
        Pet(petName:"Purp Katt", 
            petId: 5,
            petImageName: "cat1.png",
            petModelName: "art.scnassets/Cat.Purple.scn"),
        
        Pet(petName:"Daf Ducker",
            petId: 6,
            petImageName: "duck1.png",
            petModelName: "art.scnassets/Duck.Daffy.scn"),
        
        Pet(petName:"Rub Ducker",
            petId: 7,
            petImageName: "duck3.png",
            petModelName: "art.scnassets/Duck.Yellow.scn"),
        
        Pet(petName:"Lucky Froaker", 
            petId: 8,
            petImageName: "frog2.png",
            petModelName: "art.scnassets/Frog.Lucky.scn"),
        
        Pet(petName:"G Froaker",
            petId: 9,
            petImageName: "frog3.png",
            petModelName: "art.scnassets/Frog.Froak.scn"),
        Pet(petName:"Bear",
            petId: 10,
            petImageName: "bear1.png",
            unlockedInput: false),
        Pet(petName:"Doig",
            petId: 11,
            petImageName: "dog1.png",
            unlockedInput: false),
    ]
    
    public static var activePets: [Pet] = [
        // First four pets are the active party pets
        Pet(petName:"Vin",
            petId: 1,
            petImageName: "frog1.png",
            petModelName: "art.scnassets/Frog.Green.scn",
            attack: 2,
            attackPattern: ShootClosestAbility(_InputRange: 100, _InputFireRate: 3, _InputProjectileSpeed: 20, _InputProjectileDuration: 3, _InputProjectile: {()->Projectile in LaunchedProjectile(_InputDamage: 1)})),
        
        Pet(petName:"Pengwin",
            petId: 2,
            petImageName: "penguin1.png"	,
            petModelName: "art.scnassets/Penguin.001.scn",
            attack: 3,
            attackPattern: OrbitingProjectileAbility(
                _InputAbilityDamage: 1,
                _InputAbilityDuration: 10,
                _InputRotationSpeed: 10,
                _InputDistanceFromCenter: 10,
                _InputNumProjectiles: 5,
                _InputProjectile: { ()->Projectile in OrbitingPaw(_InputDamage: 1)})),
        Pet(petName:"Pink Katt",
            petId: 3,
            petImageName: "cat2.png",
            petModelName: "art.scnassets/Cat.Pink.scn",
            attackPattern: OrbitingProjectileAbility(
                _InputAbilityDamage: 1,
                _InputAbilityDuration: 10,
                _InputRotationSpeed: 15,
                _InputDistanceFromCenter: 12.5,
                _InputNumProjectiles: 5,
                _InputProjectile: { ()->Projectile in OrbitingPaw(_InputDamage: 1)})),
        
        Pet(petName:"Dol Ducker",
            petId: 4,
            petImageName: "duck1.png",
            petModelName: "art.scnassets/Duck.Dolan.scn",
            attackPattern: SpawnProjectileInRangeAbility(_InputSpawnRate: 3, _InputRange: 12.0, _InputProjectileDuration: 3, _InputProjectile: { ()->Projectile in StationaryBomb(_InputDamage: 1)})),
        
    ]
    
    public static let cameraZIndex : Float = 30;
    
    public static var inputX : CGFloat = 0
    public static var inputZ : CGFloat = 0
    
    public static var playerIsMoving : Bool = false
    public static var playerMovementSpeed : Float = 20
    
    public static var maxHungerScoreMultiplier : Float = 1.5
    public static var foodHealthMultiplier : Float = 1.2
    
    public static var numStagePresets = 3
    // default values
    public static let defaultMaxHungerScore : Int = 4
    public static let defaultFoodHealth : Int = 1
    public static let defaultFoodHungerValue : Int = 1
    public static let defaultStageCount : Int = 1
    
    // Persistent User Data Keys
    public static let userDataVersionKey = "userDataVersion"
    public static let totalScoreKey : String = "Total Score"
    public static let stageScoreKey : String = "Stage Score"
    public static let stageMaxScorekey : String = "Max Stage Score"
    public static let stageCountKey : String = "Stage Count"
    public static let foodHealthMultiplierKey : String = "Food Health Multiplier"
    public static var petModelNodeName: [String] = [
        "Frog.001 reference", "Penguin.001 reference", "Cat.001 reference", "Duck.001 reference"
    ]
    
    public static var petAbilityNodeName: [String] = [
        "PetAbility1", "petAbility2", "petAbility3", "petAbility4"
    ]
    
    struct petSelectionUIColors {
        static let selected = UIColor.systemBlue
        static let selectedHalf = UIColor.systemBlue.withAlphaComponent(0.5)
        static let neutral = UIColor.lightGray
        static let neutralHalf = UIColor.lightGray.withAlphaComponent(0.5)
        static let error = UIColor.systemRed
    }
}
