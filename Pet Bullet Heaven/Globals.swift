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
    public static var currentGameState = "mainMenu"
    public static var deltaTime: TimeInterval = 0
    public static var timeScale: Double = 1
    
    // TODO: Put growths for pet atk, spd, and exp.
    // TODO: Give values for pets without them (try designing pet values in the spreedsheet before)
    public static var pets: [Int: Pet] = [
        0: Pet(petName: "Vin",
               petId: 0,
               petImageName: "frog1.png",
               petModelName: "art.scnassets/Frog.Green.scn",
               baseAbility: SpawnProjectileInRangeAbility(_InputSpawnRate: 3, _InputRange: 10, _InputProjectileDuration: 3, _InputProjectile: {
                   ()-> Projectile in StationaryBomb(_InputDamage: 2, assetName: "IcebergV2")
               }),
               currentExp: 0,
               level: 1
              ),
        
        1: Pet(petName: "Pengwin",
               petId: 1,
               petImageName: "penguin1.png",
               petModelName: "art.scnassets/Penguin.001.scn",
               baseAbility: SpawnProjectileInRangeAbility(_InputSpawnRate: 3, _InputRange: 10, _InputProjectileDuration: 3, _InputProjectile: {
                   ()-> Projectile in StationaryBomb(_InputDamage: 2, assetName: "IcebergV2")
               }),
               currentExp: 0,
               level: 1
              ),
        
        2: Pet(petName:"Pink Katt",
               petId: 2,
               petImageName: "cat2.png",
               petModelName: "art.scnassets/Cat.Pink.scn",
               baseAbility: OrbitingProjectileAbility(
                _InputAbilityDamage: 1,
                _InputAbilityDuration: 10,
                _InputRotationSpeed: 19,
                _InputDistanceFromCenter: 6,
                _InputNumProjectiles: 3,
                _InputProjectile: { ()->Projectile in OrbitingPaw(_InputDamage: 1, assetName: "PawV5")})
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
               baseAbility: OrbitingProjectileAbility(
                _InputAbilityDamage: 3,
                _InputAbilityDuration: 10,
                _InputRotationSpeed: 4.5,
                _InputDistanceFromCenter: 13,
                _InputNumProjectiles: 3,
                _InputProjectile: { ()->Projectile in OrbitingPaw(_InputDamage: 3, assetName: "Paw 4")}),
               currentExp: 0,
               level: 1
              ),
        
        6: Pet(petName:"Rub Ducker",
               petId: 6,
               petImageName: "duck3.png",
               petModelName: "art.scnassets/Duck.Yellow.scn",
               baseAbility: ShootClosestAbility(
                _InputRange: 110,
                _InputFireRate: 5.5,
                _InputProjectileSpeed: 13,
                _InputProjectileDuration: 2.75,
                _InputProjectile: {()->Projectile in LaunchedProjectile(_InputDamage: 4, assetName: "Paw 4")}),
               currentExp: 0,
               level: 1
              ),
        
        7: Pet(petName:"Lucky Froaker",
               petId: 7,
               petImageName: "frog2.png",
               petModelName: "art.scnassets/Frog.Lucky.scn",
               baseAbility: OrbitingProjectileAbility(
                _InputAbilityDamage: 2,
                _InputAbilityDuration: 10,
                _InputRotationSpeed: 5.5,
                _InputDistanceFromCenter: 16,
                _InputNumProjectiles: 2,
                _InputProjectile: { ()->Projectile in OrbitingPaw(_InputDamage: 2, assetName: "Bubble")}),
               currentExp: 0,
               level: 1
              ),
        
        8: Pet(petName:"G Froaker",
               petId: 8,
               petImageName: "frog3.png", // Assuming image from the new dictionary format
               petModelName: "art.scnassets/Frog.Froak.scn",
               baseAbility: ShootClosestAbility(
                _InputRange: 200,
                _InputFireRate: 2.5,
                _InputProjectileSpeed: 30,
                _InputProjectileDuration: 1,
                _InputProjectile: {()->Projectile in LaunchedProjectile(_InputDamage: 1, assetName: "Bubble")}),
               currentExp: 0,
               level: 1
              ),
        
        9: Pet(petName:"Brear",
               petId: 9,
               petImageName: "bear1.png",
               petModelName: "art.scnassets/bear.1.scn",
               baseAbility: OrbitingProjectileAbility(
                _InputAbilityDamage: 4,
                _InputAbilityDuration: 10,
                _InputRotationSpeed: 4,
                _InputDistanceFromCenter: 5,
                _InputNumProjectiles: 1,
                _InputProjectile: { ()->Projectile in OrbitingPaw(_InputDamage: 1, assetName: "Paw 4")}),
               unlockedInput: false, currentExp: 0,
               level: 1
              ),
        
        10: Pet(petName:"Gum Brear",
                petId: 10,
                petImageName: "bear-gummy.png",
                petModelName: "art.scnassets/bear.g.scn",
                currentExp: 0,
                level: 1 // Assuming from context
               ),
        11: Pet(petName:"Pol Brear",
                petId: 11,
                petImageName: "bear-polar.png",
                petModelName: "art.scnassets/bear.p.scn",
                unlockedInput: false,
                currentExp: 0,
                level: 1 // Assuming from context
               ),
        12: Pet(petName:"Sad Doger",
                petId: 12,
                petImageName: "dog.png",
                petModelName: "art.scnassets/dog1.scn",
                currentExp: 0,
                level: 1 // Assuming from context
               ),
        13: Pet(petName:"Lucky Doger",
                petId: 13,
                petImageName: "dog2.png",
                petModelName: "art.scnassets/dog2.scn",
                currentExp: 0,
                level: 1 // Assuming from context
               ),
        14: Pet(petName:"Sparky Doger",
                petId: 14,
                petImageName: "dog3.png",
                petModelName: "art.scnassets/dog3.scn",
                currentExp: 0,
                level: 1 // Assuming from context
               ),
    ]
    
    public static var activePets: [Int] = [
        // First four pets are the active party pets
        0, 1, 2, 3 // Use the new ids starting from 0
    ]
    
    public static var specialFoods: [FoodData] = [
        FoodData(
           name: "MuffinCrumbs",
           type: "treasure",
           initialSpeed: 1,
           health: 10,
           physicsDimensions: SCNVector3(3, 3, 3),
           hungerValue: 8,
           assetName: "art.scnassets/Food Models/Crumbs.scn",
           initialEXP: 1,
           EXPGrowth: 1.0,
           healthGrowth: 1.0,
           hungerGrowth: 1.0,
           speedGrowth: 1.0),
        FoodData(
           name: "MuffinBits",
           type: "treasure",
           initialSpeed: 20,
           health: 10,
           physicsDimensions: SCNVector3(3, 3, 3),
           hungerValue: 8,
           assetName: "art.scnassets/Food Models/Crumbs.scn",
           initialEXP: 1,
           EXPGrowth: 1.0,
           healthGrowth: 1.0,
           hungerGrowth: 1.0,
           speedGrowth: 1.0)
    ]
    public static var stage1Foods: [(Int, FoodData)] = [
        (1,
         FoodData(
            name: "Muffin",
            type: "treasure",
            initialSpeed: 1,
            health: 10,
            physicsDimensions: SCNVector3(3, 3, 3),
            hungerValue: 8,
            assetName: "art.scnassets/Food Models/Muffin.scn",
            initialEXP: 1,
            EXPGrowth: 1.0,
            healthGrowth: 1.0,
            hungerGrowth: 1.0,
            speedGrowth: 1.0)),
        (40,
         FoodData(
            name: "StationaryMushroom",
            type: "base",
            initialSpeed: 3.5,
            health: 5,
            physicsDimensions: SCNVector3(1.5, 3, 1.5),
            hungerValue: 2,
            assetName: "art.scnassets/Food Models/Mushroom.scn",
            initialEXP: 1,
            EXPGrowth: 1.0,
            healthGrowth: 1.0,
            hungerGrowth: 1.0,
            speedGrowth: 1.0)),
        (30,
         FoodData(
            name: "DirectionalCarrot",
            type: "directional",
            initialSpeed: 3.5,
            health: 5,
            physicsDimensions: SCNVector3(1.5, 3, 1.5),
            hungerValue: 2,
            assetName: "art.scnassets/Food Models/CarrotV2.scn",
            initialEXP: 1,
            EXPGrowth: 1.0,
            healthGrowth: 1.0,
            hungerGrowth: 1.0,
            speedGrowth: 1.0)),
        (9,
         FoodData(
            name: "FleeingCarrot",
            type: "flee",
            initialSpeed: 3.5,
            health: 5,
            physicsDimensions: SCNVector3(1.5, 3, 1.5),
            hungerValue: 2,
            assetName: "art.scnassets/Food Models/CarrotV2.scn",
            initialEXP: 1,
            EXPGrowth: 1.0,
            healthGrowth: 1.0,
            hungerGrowth: 1.0,
            speedGrowth: 1.0)),
        (20,
         FoodData(
            name: "RoamingCarrot",
            type: "roam",
            initialSpeed: 3.5,
            health: 5,
            physicsDimensions: SCNVector3(1.5, 3, 1.5),
            hungerValue: 2,
            assetName: "art.scnassets/Food Models/CarrotV2.scn",
            initialEXP: 1,
            EXPGrowth: 1.0,
            healthGrowth: 1.0,
            hungerGrowth: 1.0,
            speedGrowth: 1.0))
    ]
    public static var stage2Foods: [(Int, FoodData)] = [
        (1,
         FoodData(
            name: "Muffin",
            type: "treasure",
            initialSpeed: 5,
            health: 10,
            physicsDimensions: SCNVector3(3, 3, 3),
            hungerValue: 8,
            assetName: "art.scnassets/Food Models/Muffin.scn",
            initialEXP: 1,
            EXPGrowth: 1.0,
            healthGrowth: 1.0,
            hungerGrowth: 1.0,
            speedGrowth: 1.0)),
        (40,
         FoodData(
            name: "StationaryKelp",
            type: "base",
            initialSpeed: 3,
            health: 3,
            physicsDimensions: SCNVector3(x: 3, y: 3, z: 3),
            hungerValue: 4,
            assetName: "art.scnassets/Food Models/Kelp.scn",
            initialEXP: 1,
            EXPGrowth: 1.0,
            healthGrowth: 1.0,
            hungerGrowth: 1.0,
            speedGrowth: 1.0)),
        (30,
         FoodData(
            name: "DirectionalBanana",
            type: "directional",
            initialSpeed: 3,
            health: 3,
            physicsDimensions: SCNVector3(x: 3, y: 3, z: 3),
            hungerValue: 4,
            assetName: "art.scnassets/Food Models/Banana.scn",
            initialEXP: 1,
            EXPGrowth: 1.0,
            healthGrowth: 1.0,
            hungerGrowth: 1.0,
            speedGrowth: 1.0)),
        (9,
         FoodData(
            name: "FleeingBanana",
            type: "flee",
            initialSpeed: 3,
            health: 3,
            physicsDimensions: SCNVector3(x: 3, y: 3, z: 3),
            hungerValue: 4,
            assetName: "art.scnassets/Food Models/Banana.scn",
            initialEXP: 1,
            EXPGrowth: 1.0,
            healthGrowth: 1.0,
            hungerGrowth: 1.0,
            speedGrowth: 1.0)),
        (20,
         FoodData(
            name: "RoamingBanana",
            type: "roam",
            initialSpeed: 3,
            health: 3,
            physicsDimensions: SCNVector3(x: 3, y: 3, z: 3),
            hungerValue: 4,
            assetName: "art.scnassets/Food Models/Banana.scn",
            initialEXP: 1,
            EXPGrowth: 1.0,
            healthGrowth: 1.0,
            hungerGrowth: 1.0,
            speedGrowth: 1.0))
    ]
    public static var stage3Foods: [(Int, FoodData)] = [
        (1,
         FoodData(
            name: "Muffin",
            type: "treasure",
            initialSpeed: 5,
            health: 10,
            physicsDimensions: SCNVector3(3, 3, 3),
            hungerValue: 8,
            assetName: "art.scnassets/Food Models/Muffin.scn",
            initialEXP: 1,
            EXPGrowth: 1.0,
            healthGrowth: 1.0,
            hungerGrowth: 1.0,
            speedGrowth: 1.0)),
        (40,
         FoodData(
            name: "StationaryCottonCandy",
            type: "base",
            initialSpeed: 3.5,
            health: 5,
            physicsDimensions: SCNVector3(1.5, 3, 1.5),
            hungerValue: 2,
            assetName: "art.scnassets/Food Models/CottenCandy.scn",
            initialEXP: 1,
            EXPGrowth: 1.0,
            healthGrowth: 1.0,
            hungerGrowth: 1.0,
            speedGrowth: 1.0)),
        (30,
         FoodData(
            name: "DirectionalDonut",
            type: "directional",
            initialSpeed: 3.5,
            health: 5,
            physicsDimensions: SCNVector3(1.5, 3, 1.5),
            hungerValue: 2,
            assetName: "art.scnassets/Food Models/Donut.scn",
            initialEXP: 1,
            EXPGrowth: 1.0,
            healthGrowth: 1.0,
            hungerGrowth: 1.0,
            speedGrowth: 1.0)),
        (9,
         FoodData(
            name: "FleeingDonut",
            type: "flee",
            initialSpeed: 3.5,
            health: 5,
            physicsDimensions: SCNVector3(1.5, 3, 1.5),
            hungerValue: 2,
            assetName: "art.scnassets/Food Models/Donut.scn",
            initialEXP: 1,
            EXPGrowth: 1.0,
            healthGrowth: 1.0,
            hungerGrowth: 1.0,
            speedGrowth: 1.0)),
        (20,
         FoodData(
            name: "RoamingDonut",
            type: "roam",
            initialSpeed: 3.5,
            health: 5,
            physicsDimensions: SCNVector3(1.5, 3, 1.5),
            hungerValue: 2,
            assetName: "art.scnassets/Food Models/Donut.scn",
            initialEXP: 1,
            EXPGrowth: 1.0,
            healthGrowth: 1.0,
            hungerGrowth: 1.0,
            speedGrowth: 1.0))
    ]
    
    public static var foodSCNModels: [String: SCNNode] = [:]
    
    
    public static var foodGroups = [stage1Foods, stage2Foods, stage3Foods]
    
    public static let cameraZIndex : Float = 30;
    
    public static var inputX : CGFloat = 0
    public static var inputZ : CGFloat = 0
    
    public static var playerIsMoving : Bool = false
    public static var playerMovementSpeed : Float = 20
    
    public static var maxHungerScoreMultiplier : Float = 1.5
    public static var foodHealthMultiplier : Float = 1.2
    
    public static var numStagePresets = 3
    
    //statistics
    public static var snacksEaten = 0
    public static var damageDone = 0
    public static var totalScore = 0
    public static var stagesPassed = 0
    
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
    
    var initialEXP: Int
    var EXPGrowth: Float
    var healthGrowth: Float
    var hungerGrowth: Float
    var speedGrowth: Float
}
