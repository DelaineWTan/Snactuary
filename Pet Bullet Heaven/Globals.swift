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
    public static var activePets: [Pet] = [
        Pet(petName:"Bunni",petId: 1),
        Pet(petName:"Frogger",petId: 2),
        Pet(petName:"Ticken",petId: 3),
        Pet(petName:"Foxxy",petId: 4)
    ]
    
    public static var allPets: [Pet] = [
        Pet(petName:"Horze",petId: 5),
        Pet(petName:"Furret",petId: 6),
        Pet(petName:"Krockerdile",petId: 7),
        Pet(petName:"Pengwin",petId: 8),
        Pet(petName:"Axiloto",petId: 8)
        // Add more pets as needed
    ]
    public static let cameraZIndex:Float = 30;
}
