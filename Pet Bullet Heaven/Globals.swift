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
        Pet(petName:"Frogger",petId: 1, petImageName: "art.scnassets/frog.png", petModelName: "art.scnassets/FrogFroak.scn", attack: 2, attackPattern: OrbitingProjectileAbility(_InputAbilityDamage: 1, _InputAbilityDuration: 10, _InputRotationSpeed: 5, _InputDistanceFromCenter: 7.5, _InputNumProjectiles: 5, _InputProjectile: { ()->Projectile in OrbitingPaw(_InputDamage: 1)})),
        Pet(petName:"Pengwin",petId: 2, petImageName: "art.scnassets/locked.png", petModelName: "art.scnassets/Penguin.001.scn", attack: 3, attackPattern: OrbitingProjectileAbility(_InputAbilityDamage: 1, _InputAbilityDuration: 10, _InputRotationSpeed: 10, _InputDistanceFromCenter: 10, _InputNumProjectiles: 5, _InputProjectile: { ()->Projectile in OrbitingPaw(_InputDamage: 1)})),
        Pet(petName:"Hello Katt",petId: 3, petImageName: "art.scnassets/locked.png", petModelName: "art.scnassets/Cat.001.scn", attackPattern: OrbitingProjectileAbility(_InputAbilityDamage: 1, _InputAbilityDuration: 10, _InputRotationSpeed: 15, _InputDistanceFromCenter: 12.5, _InputNumProjectiles: 5, _InputProjectile: { ()->Projectile in OrbitingPaw(_InputDamage: 1)})),
        Pet(petName:"Ducker",petId: 4, petImageName: "art.scnassets/locked.png", petModelName: "art.scnassets/Duck.001.scn", attackPattern: OrbitingProjectileAbility(_InputAbilityDamage: 1, _InputAbilityDuration: 10, _InputRotationSpeed: 20, _InputDistanceFromCenter: 15, _InputNumProjectiles: 5, _InputProjectile: { ()->Projectile in OrbitingPaw(_InputDamage: 1)})),
        Pet(petName:"Bunni", petId: 5, petImageName: "art.scnassets/bunny.gif"),
        Pet(petName:"Ticken",petId: 6, petImageName: "art.scnassets/chicken.png"),
        Pet(petName:"Foxxy",petId: 7, petImageName: "art.scnassets/foxxy.jpeg"),
        // Non-active pets under
        Pet(petName:"Furret",petId: 8),
        Pet(petName:"Krockerdile",petId: 9),
        Pet(petName:"Axiloto",petId: 10),
        Pet(petName:"Dwagon",petId: 11),
        Pet(petName:"Doggo",petId: 12),
        // Add more pets as needed
    ]
    
    public static var activePets: [Pet] = [
        // First four pets are the active party pets
        Pet(petName:"Frogger",petId: 1, petImageName: "art.scnassets/frog.png", petModelName: "art.scnassets/FrogFroak.scn", attack: 2, attackPattern: OrbitingProjectileAbility(_InputAbilityDamage: 1, _InputAbilityDuration: 10, _InputRotationSpeed: 5, _InputDistanceFromCenter: 7.5, _InputNumProjectiles: 5, _InputProjectile: { ()->Projectile in OrbitingPaw(_InputDamage: 1)})),
        Pet(petName:"Pengwin",petId: 2, petImageName: "art.scnassets/locked.png", petModelName: "art.scnassets/Penguin.001.scn", attack: 3, attackPattern: OrbitingProjectileAbility(_InputAbilityDamage: 1, _InputAbilityDuration: 10, _InputRotationSpeed: 10, _InputDistanceFromCenter: 10, _InputNumProjectiles: 5, _InputProjectile: { ()->Projectile in OrbitingPaw(_InputDamage: 1)})),
        Pet(petName:"Hello Katt",petId: 3, petImageName: "art.scnassets/locked.png", petModelName: "art.scnassets/Cat.001.scn", attackPattern: OrbitingProjectileAbility(_InputAbilityDamage: 1, _InputAbilityDuration: 10, _InputRotationSpeed: 15, _InputDistanceFromCenter: 12.5, _InputNumProjectiles: 5, _InputProjectile: { ()->Projectile in OrbitingPaw(_InputDamage: 1)})),
        Pet(petName:"Ducker",petId: 4, petImageName: "art.scnassets/locked.png", petModelName: "art.scnassets/Duck.001.scn", attackPattern: OrbitingProjectileAbility(_InputAbilityDamage: 1, _InputAbilityDuration: 10, _InputRotationSpeed: 20, _InputDistanceFromCenter: 15, _InputNumProjectiles: 5, _InputProjectile: { ()->Projectile in OrbitingPaw(_InputDamage: 1)})),
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
}
