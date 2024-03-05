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
        Pet(petName:"Bunni",petId: 1),
        Pet(petName:"Frogger",petId: 2),
        Pet(petName:"Ticken",petId: 3),
        Pet(petName:"Foxxy",petId: 4),
        // Non-active pets under
        Pet(petName:"Horze",petId: 5),
        Pet(petName:"Furret",petId: 6),
        Pet(petName:"Krockerdile",petId: 7),
        Pet(petName:"Pengwin",petId: 8),
        Pet(petName:"Axiloto",petId: 9),
        Pet(petName:"Dwagon",petId: 10)
        // Add more pets as needed
    ]
    public static let cameraZIndex : Float = 30;
    
    public static var inputX : CGFloat = 0
    public static var inputZ : CGFloat = 0
    
    public static var playerIsMoving : Bool = false
    public static var playerMovementSpeed : Float = 20
}

extension Comparable {
    func clamp(min: Self, max: Self) -> Self {
        return Swift.max(min, Swift.min(self, max))
    }
}
