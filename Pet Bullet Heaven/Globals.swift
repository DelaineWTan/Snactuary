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
    public static var userDataVersion = 2
    
    public static var mainScene = SCNScene(named: "art.scnassets/main.scn")!
    public static var playerNode = mainScene.rootNode.childNode(withName: "mainPlayer", recursively: true)!
    
    public static var inMainMenu = true
    public static var deltaTime: TimeInterval = 0
    public static var timeScale: Double = 1
    
    public static var pets: [Int: Pet] = [
        0: Pet(petName: "Vin",
               petId: 0,
               petImageName: "frog1.png",
               petModelName: "art.scnassets/Frog.Green.scn",
               baseAttack: 2,
               attackPattern: ShootClosestAbility(
                _InputRange: 170,
                _InputFireRate: 100, // TODO: Fix model memory issue first
                _InputProjectileSpeed: 22,
                _InputProjectileDuration: 1.25,
                _InputProjectile: {()->Projectile in LaunchedProjectile(_InputDamage: 2)}),
               currentExp: 0,
               level: 1
              ),
        
        1: Pet(petName: "Pengwin",
               petId: 1,
               petImageName: "penguin1.png",
               petModelName: "art.scnassets/Penguin.001.scn",
               baseAttack: 3,
               attackPattern: OrbitingProjectileAbility(
                _InputAbilityDamage: 3,
                _InputAbilityDuration: 10,
                _InputRotationSpeed: 7,
                _InputDistanceFromCenter: 15,
                _InputNumProjectiles: 10,
                _InputProjectile: { ()->Projectile in OrbitingPaw(_InputDamage: 2)}),
               currentExp: 0,
               level: 1
              ),
        
        2: Pet(petName:"P Katt",
               petId: 2,
               petImageName: "cat2.png",
               petModelName: "art.scnassets/Cat.Pink.scn",
               attackPattern: OrbitingProjectileAbility(
                _InputAbilityDamage: 1,
                _InputAbilityDuration: 10,
                _InputRotationSpeed: 19,
                _InputDistanceFromCenter: 6,
                _InputNumProjectiles: 3,
                _InputProjectile: { ()->Projectile in OrbitingPaw(_InputDamage: 1)})
              ),
        
        3: Pet(petName:"Dol Ducker",
               petId: 3,
               petImageName: "duck2.png",
               petModelName: "art.scnassets/Duck.Dolan.scn",
               currentExp: 0,
               level: 1
              ),
        
        4: Pet(petName:"Purp Katt",
               petId: 4,
               petImageName: "cat1.png",
               petModelName: "art.scnassets/Cat.Purple.scn",
               currentExp: 0,
               level: 1
              ),
        
        5: Pet(petName:"Daf Ducker",
               petId: 5,
               petImageName: "duck1.png",
               petModelName: "art.scnassets/Duck.Daffy.scn",
               attackPattern: OrbitingProjectileAbility(
                _InputAbilityDamage: 3,
                _InputAbilityDuration: 10,
                _InputRotationSpeed: 4.5,
                _InputDistanceFromCenter: 13,
                _InputNumProjectiles: 3,
                _InputProjectile: { ()->Projectile in OrbitingPaw(_InputDamage: 3)}),
               currentExp: 0,
               level: 1
              ),
        
        6: Pet(petName:"Rub Ducker",
               petId: 6,
               petImageName: "duck3.png",
               petModelName: "art.scnassets/Duck.Yellow.scn",
               attackPattern: ShootClosestAbility(
                _InputRange: 110,
                _InputFireRate: 5.5,
                _InputProjectileSpeed: 13,
                _InputProjectileDuration: 2.75,
                _InputProjectile: {()->Projectile in LaunchedProjectile(_InputDamage: 4)}),
               currentExp: 0,
               level: 1
              ),
        
        7: Pet(petName:"Lucky Froaker",
               petId: 7,
               petImageName: "frog2.png",
               petModelName: "art.scnassets/Frog.Lucky.scn",
               attackPattern: OrbitingProjectileAbility(
                _InputAbilityDamage: 2,
                _InputAbilityDuration: 10,
                _InputRotationSpeed: 5.5,
                _InputDistanceFromCenter: 16,
                _InputNumProjectiles: 2,
                _InputProjectile: { ()->Projectile in OrbitingPaw(_InputDamage: 2)}),
               currentExp: 0,
               level: 1
              ),
        
        8: Pet(petName:"G Froaker",
               petId: 8,
               petImageName: "frog3.png", // Assuming image from the new dictionary format
               petModelName: "art.scnassets/Frog.Froak.scn",
               attackPattern: ShootClosestAbility(
                _InputRange: 200,
                _InputFireRate: 2.5,
                _InputProjectileSpeed: 30,
                _InputProjectileDuration: 1,
                _InputProjectile: {()->Projectile in LaunchedProjectile(_InputDamage: 1)}),
               currentExp: 0,
               level: 1
              ),
        
        9: Pet(petName:"Bear",
               petId: 9,
               petImageName: "bear1.png",
               attackPattern: OrbitingProjectileAbility(
                _InputAbilityDamage: 4,
                _InputAbilityDuration: 10,
                _InputRotationSpeed: 4,
                _InputDistanceFromCenter: 5,
                _InputNumProjectiles: 1,
                _InputProjectile: { ()->Projectile in OrbitingPaw(_InputDamage: 1)}),
               unlockedInput: false, currentExp: 0,
               level: 1 // Assuming from context
              ),
        
        10: Pet(petName:"Doig",
                petId: 10,
                petImageName: "dog1.png",
                unlockedInput: false, currentExp: 0,
                level: 1 // Assuming from context
               )
    ]
    
    public static var activePets: [Int] = [
        // First four pets are the active party pets
        0, 1, 2, 3 // Use the new ids starting from 0
    ]
    
    public static var stage1Foods: [(Int, FoodData)] = [
        (100,
         FoodData(
            name: "StationaryMushroom",
            type: "base",
            initialSpeed: 3.5,
            health: 5,
            physicsDimensions: SCNVector3(1.5, 3, 1.5),
            hungerValue: 2,
            assetName: "art.scnassets/Food Models/CarrotV2.scn")),
        (100,
         FoodData(
            name: "DirectionalCarrot",
            type: "directional",
            initialSpeed: 3.5,
            health: 5,
            physicsDimensions: SCNVector3(1.5, 3, 1.5),
            hungerValue: 2,
            assetName: "art.scnassets/Food Models/CarrotV2.scn")),
        (100,
         FoodData(
            name: "RoamingCarrot",
            type: "roaming",
            initialSpeed: 3.5,
            health: 5,
            physicsDimensions: SCNVector3(1.5, 3, 1.5),
            hungerValue: 2,
            assetName: "art.scnassets/Food Models/CarrotV2.scn")),
        (10,
         FoodData(
            name: "Muffin",
            type: "treasure",
            initialSpeed: 5,
            health: 10,
            physicsDimensions: SCNVector3(3, 3, 3),
            hungerValue: 8,
            assetName: "art.scnassets/Food Models/Donut.scn"))
    ]
    public static var stage2Foods: [(Int, FoodData)] = [
        (100,
         FoodData(
            name: "Banana",
            type: "base",
            initialSpeed: 3,
            health: 3,
            physicsDimensions: SCNVector3(x: 3, y: 3, z: 3),
            hungerValue: 4,
            assetName: "art.scnassets/Banana.scn")),
        (100,
         FoodData(
            name: "Banana",
            type: "base",
            initialSpeed: 3,
            health: 3,
            physicsDimensions: SCNVector3(x: 3, y: 3, z: 3),
            hungerValue: 4,
            assetName: "art.scnassets/Banana.scn")),
        (100,
         FoodData(
            name: "Banana",
            type: "base",
            initialSpeed: 3,
            health: 3,
            physicsDimensions: SCNVector3(x: 3, y: 3, z: 3),
            hungerValue: 4,
            assetName: "art.scnassets/Banana.scn")),
        (10,
         FoodData(
            name: "Donut",
            type: "treasure",
            initialSpeed: 5,
            health: 10,
            physicsDimensions: SCNVector3(3, 3, 3),
            hungerValue: 8,
            assetName: "art.scnassets/Food Models/Donut.scn"))
    ]
    public static var stage3Foods: [(Int, FoodData)] = [
        (100,
         FoodData(
            name: "Donut",
            type: "base",
            initialSpeed: 3.5,
            health: 5,
            physicsDimensions: SCNVector3(1.5, 3, 1.5),
            hungerValue: 2,
            assetName: "art.scnassets/Food Models/Donut.scn")),
        (100,
         FoodData(
            name: "Donut",
            type: "base",
            initialSpeed: 3.5,
            health: 5,
            physicsDimensions: SCNVector3(1.5, 3, 1.5),
            hungerValue: 2,
            assetName: "art.scnassets/Food Models/Donut.scn")),
        (100,
         FoodData(
            name: "Donut",
            type: "base",
            initialSpeed: 3.5,
            health: 5,
            physicsDimensions: SCNVector3(1.5, 3, 1.5),
            hungerValue: 2,
            assetName: "art.scnassets/Food Models/Donut.scn")),
        (10,
         FoodData(
            name: "Donut",
            type: "treasure",
            initialSpeed: 5,
            health: 10,
            physicsDimensions: SCNVector3(3, 3, 3),
            hungerValue: 8,
            assetName: "art.scnassets/Food Models/Donut.scn"))
    ]
    
    public static var foodSCNModels: [String: SCNNode] = [:]
    
    
    public static var foodGroups = [stage1Foods, stage1Foods, stage1Foods]
    
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
        static let locked = UIColor.gray
    }
}

public struct FoodData {
    var name: String
    var type: String
    var initialSpeed: Float
    var health: Int
    var physicsDimensions: SCNVector3
    var hungerValue: Int
    var assetName: String
}
