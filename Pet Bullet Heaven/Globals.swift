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
        // First four pets are the active party pets
        Pet(petName:"Bunni", petId: 1, petImageName: "art.scnassets/bunny.gif"),
        Pet(petName:"Frogger",petId: 2, petImageName: "art.scnassets/frog.png"),
        Pet(petName:"Ticken",petId: 3, petImageName: "art.scnassets/chicken.png"),
        Pet(petName:"Foxxy",petId: 4, petImageName: "art.scnassets/foxxy.jpeg"),
        // Non-active pets under
        Pet(petName:"Horze",petId: 5),
        Pet(petName:"Furret",petId: 6),
        Pet(petName:"Krockerdile",petId: 7),
        Pet(petName:"Pengwin",petId: 8),
        Pet(petName:"Axiloto",petId: 9),
        Pet(petName:"Dwagon",petId: 10),
        Pet(petName:"Doggo",petId: 11)
        // Add more pets as needed
    ]
    
    public static var activePets: [Pet] = [
        // First four pets are the active party pets
        Pet(petName:"Bunni", petId: 1, petImageName: "art.scnassets/bunny.gif"),
        Pet(petName:"Frogger",petId: 2, petImageName: "art.scnassets/frog.png"),
        Pet(petName:"Ticken",petId: 3, petImageName: "art.scnassets/chicken.png"),
        Pet(petName:"Foxxy",petId: 4, petImageName: "art.scnassets/foxxy.jpeg")
    ]
    
    public static let cameraZIndex : Float = 30;
    
    public static var inputX : CGFloat = 0
    public static var inputZ : CGFloat = 0
    
    public static var playerIsMoving : Bool = false
    public static var playerMovementSpeed : Float = 20
    
    public static var maxHungerScoreMultiplier : Float = 1.5
    public static var foodHealthMultiplier : Float = 1.2
    public static var stageProgressCount : Int = 1
    public static var currStageFoodHealth : Int = 1
}

extension Comparable {
    func clamp(min: Self, max: Self) -> Self {
        return Swift.max(min, Swift.min(self, max))
    }
}
