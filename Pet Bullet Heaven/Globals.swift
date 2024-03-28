//
//  Constants.swift
//  Pet Bullet Heaven
//
//  Created by Delaine on 2024-02-07.
//
import UIKit
import SwiftUI
import Combine

public class Globals {
    public static var pets: [Pet] = [
        Pet(petName:"Frogger",petId: 1, petImageName: "art.scnassets/frog.png", petModelName: "art.scnassets/Frog.001.scn", attackPattern: OrbitingProjectileAbility(_InputAbilityDamage: 1, _InputAbilityDuration: 10, _InputRotationSpeed: 5, _InputDistanceFromCenter: 7.5, _InputNumProjectiles: 5)),
        Pet(petName:"Pengwin",petId: 2, petImageName: "art.scnassets/locked.png", petModelName: "art.scnassets/Penguin.001.scn", attackPattern: OrbitingProjectileAbility(_InputAbilityDamage: 1, _InputAbilityDuration: 10, _InputRotationSpeed: 10, _InputDistanceFromCenter: 10, _InputNumProjectiles: 5)),
        Pet(petName:"Hello Katt",petId: 3, petImageName: "art.scnassets/locked.png", petModelName: "art.scnassets/Cat.001.scn", attackPattern: OrbitingProjectileAbility(_InputAbilityDamage: 1, _InputAbilityDuration: 10, _InputRotationSpeed: 15, _InputDistanceFromCenter: 12.5, _InputNumProjectiles: 5)),
        Pet(petName:"Ducker",petId: 4, petImageName: "art.scnassets/locked.png", petModelName: "art.scnassets/Duck.001.scn", attackPattern: OrbitingProjectileAbility(_InputAbilityDamage: 1, _InputAbilityDuration: 10, _InputRotationSpeed: 20, _InputDistanceFromCenter: 15, _InputNumProjectiles: 5)),
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
        Pet(petName:"Frogger",petId: 1, petImageName: "art.scnassets/frog.png", petModelName: "art.scnassets/Frog.001.scn", attackPattern: OrbitingProjectileAbility(_InputAbilityDamage: 1, _InputAbilityDuration: 10, _InputRotationSpeed: 5, _InputDistanceFromCenter: 7.5, _InputNumProjectiles: 5)),
        Pet(petName:"Pengwin",petId: 2, petImageName: "art.scnassets/locked.png", petModelName: "art.scnassets/Penguin.001.scn", attackPattern: OrbitingProjectileAbility(_InputAbilityDamage: 1, _InputAbilityDuration: 10, _InputRotationSpeed: 10, _InputDistanceFromCenter: 10, _InputNumProjectiles: 5)),
        Pet(petName:"Hello Katt",petId: 3, petImageName: "art.scnassets/locked.png", petModelName: "art.scnassets/Cat.001.scn", attackPattern: OrbitingProjectileAbility(_InputAbilityDamage: 1, _InputAbilityDuration: 10, _InputRotationSpeed: 15, _InputDistanceFromCenter: 12.5, _InputNumProjectiles: 5)),
        Pet(petName:"Ducker",petId: 4, petImageName: "art.scnassets/locked.png", petModelName: "art.scnassets/Duck.001.scn", attackPattern: OrbitingProjectileAbility(_InputAbilityDamage: 1, _InputAbilityDuration: 10, _InputRotationSpeed: 20, _InputDistanceFromCenter: 15, _InputNumProjectiles: 5))
    ]
    
    public static let cameraZIndex : Float = 30;
    
    public static var inputX : CGFloat = 0
    public static var inputZ : CGFloat = 0
    
    public static var playerIsMoving : Bool = false
    public static var playerMovementSpeed : Float = 20
    
    public static var petModelNodeName: [String] = [
        "", "", "", ""
    ]
    
    public static var petAbilityNodeName: [String] = [
        "PetAbility1", "petAbility2", "petAbility3", "petAbility4"
    ]
}

extension Comparable {
    func clamp(min: Self, max: Self) -> Self {
        return Swift.max(min, Swift.min(self, max))
    }
}
