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
        Pet(petName:"Froaker",
            petId: 1,
            petImageName: "art.scnassets/frog.png",
            petModelName: "art.scnassets/Frog.Froak.scn",
            attack: 2,
            attackPattern: ShootClosestAbility(
                _InputRange: 170,
                _InputFireRate: 3.75,
                _InputProjectileSpeed: 22,
                _InputProjectileDuration: 1.25,
                _InputProjectile: {()->Projectile in LaunchedProjectile(_InputDamage: 2)})),
        
        Pet(petName:"Pengwin",
            petId: 2,
            petImageName: "art.scnassets/locked.png",
            petModelName: "art.scnassets/Penguin.001.scn",
            attack: 3,
            attackPattern: OrbitingProjectileAbility(
                _InputAbilityDamage: 2,
                _InputAbilityDuration: 10,
                _InputRotationSpeed: 7,
                _InputDistanceFromCenter: 11,
                _InputNumProjectiles: 2,
                _InputProjectile: { ()->Projectile in OrbitingPaw(_InputDamage: 2)})),
        
        Pet(petName:"P Katt",
            petId: 3,
            petImageName: "art.scnassets/locked.png",
            petModelName: "art.scnassets/Cat.Pink.scn",
            attackPattern: OrbitingProjectileAbility(
                _InputAbilityDamage: 1,
                _InputAbilityDuration: 10,
                _InputRotationSpeed: 19,
                _InputDistanceFromCenter: 6,
                _InputNumProjectiles: 3,
                _InputProjectile: { ()->Projectile in OrbitingPaw(_InputDamage: 1)})),
        
        Pet(petName:"Dol Ducker",
            petId: 4,
            petImageName: "art.scnassets/locked.png",
            petModelName: "art.scnassets/Duck.Dolan.scn",
            attackPattern: SpawnProjectileInRangeAbility(
                _InputSpawnRate: 3,
                _InputRange: 32.0,
                _InputProjectileDuration: 3,
                _InputProjectile: { ()->Projectile in StationaryBomb(_InputDamage: 3)})),
        
        // bomb pounce
        Pet(petName:"Purp Katt",
            petId: 5,
            petModelName: "art.scnassets/Cat.Purple.scn"),
        
        // orbit
        Pet(petName:"Daf Ducker",
            petId: 6,
            petModelName: "art.scnassets/Duck.Daffy.scn",
            attackPattern: OrbitingProjectileAbility(
                _InputAbilityDamage: 3,
                _InputAbilityDuration: 10,
                _InputRotationSpeed: 4.5,
                _InputDistanceFromCenter: 13,
                _InputNumProjectiles: 3,
                _InputProjectile: { ()->Projectile in OrbitingPaw(_InputDamage: 3)})),
        
        // shoot a GUN
        Pet(petName:"Rub Ducker",
            petId: 7,
            petModelName: "art.scnassets/Duck.Yellow.scn",
            attackPattern: ShootClosestAbility(
                _InputRange: 110,
                _InputFireRate: 5.5,
                _InputProjectileSpeed: 13,
                _InputProjectileDuration: 2.75,
                _InputProjectile: {()->Projectile in LaunchedProjectile(_InputDamage: 4)})
            ),
        
        // orbit
        Pet(petName:"Lucky Froaker",
            petId: 8,
            petModelName: "art.scnassets/Frog.Lucky.scn",
            attackPattern: OrbitingProjectileAbility(
                _InputAbilityDamage: 2,
                _InputAbilityDuration: 10,
                _InputRotationSpeed: 5.5,
                _InputDistanceFromCenter: 16,
                _InputNumProjectiles: 2,
                _InputProjectile: { ()->Projectile in OrbitingPaw(_InputDamage: 2)})),
        
        // shoot water shuriken
        Pet(petName:"G Froaker",
            petId: 9,
            petModelName: "art.scnassets/Frog.Green.scn",
            attackPattern: ShootClosestAbility(
                _InputRange: 200,
                _InputFireRate: 2.5,
                _InputProjectileSpeed: 30,
                _InputProjectileDuration: 1,
                _InputProjectile: {()->Projectile in LaunchedProjectile(_InputDamage: 1)})),
        
        // orbit
        Pet(petName:"Bear",
            petId: 10,
            attackPattern: OrbitingProjectileAbility(
                _InputAbilityDamage: 4,
                _InputAbilityDuration: 10,
                _InputRotationSpeed: 4,
                _InputDistanceFromCenter: 5,
                _InputNumProjectiles: 1,
                _InputProjectile: { ()->Projectile in OrbitingPaw(_InputDamage: 1)}), 
                unlockedInput: false),
            
        
        // bomb
        Pet(petName:"Doig",
            petId: 11,
            unlockedInput: false),
    ]
    
    public static var activePets: [Pet] = [
        // First four pets are the active party pets
        Pet(petName:"Froaker",
            petId: 1,
            petImageName: "art.scnassets/frog.png",
            petModelName: "art.scnassets/Frog.Froak.scn",
            attack: 2,
            attackPattern: ShootClosestAbility(
                _InputRange: 170,
                _InputFireRate: 3.75,
                _InputProjectileSpeed: 22,
                _InputProjectileDuration: 1.25,
                _InputProjectile: {()->Projectile in LaunchedProjectile(_InputDamage: 2)})),
        
        Pet(petName:"Pengwin",
            petId: 2,
            petImageName: "art.scnassets/locked.png",
            petModelName: "art.scnassets/Penguin.001.scn",
            attack: 3,
            attackPattern: OrbitingProjectileAbility(
                _InputAbilityDamage: 2,
                _InputAbilityDuration: 10,
                _InputRotationSpeed: 7,
                _InputDistanceFromCenter: 11,
                _InputNumProjectiles: 2,
                _InputProjectile: { ()->Projectile in OrbitingPaw(_InputDamage: 2)})),
        
        Pet(petName:"P Katt",
            petId: 3,
            petImageName: "art.scnassets/locked.png",
            petModelName: "art.scnassets/Cat.Pink.scn",
            attackPattern: OrbitingProjectileAbility(
                _InputAbilityDamage: 1,
                _InputAbilityDuration: 10,
                _InputRotationSpeed: 19,
                _InputDistanceFromCenter: 6,
                _InputNumProjectiles: 3,
                _InputProjectile: { ()->Projectile in OrbitingPaw(_InputDamage: 1)})),
        
        Pet(petName:"Dol Ducker",
            petId: 4,
            petImageName: "art.scnassets/locked.png",
            petModelName: "art.scnassets/Duck.Dolan.scn",
            attackPattern: SpawnProjectileInRangeAbility(
                _InputSpawnRate: 3,
                _InputRange: 32.0,
                _InputProjectileDuration: 3,
                _InputProjectile: { ()->Projectile in StationaryBomb(_InputDamage: 1)})),
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
    public static let defaultMaxHungerScore : Int = 32
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
