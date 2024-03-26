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
    // might need more properties yea, add more if you see fit DO NOT CHANGE THE EXISTING ONES and update the constructor and Globals define pets as well thx :DDDDDD
    
    init (petName: String, petId: Int) {
        id = petId;
        name = petName;
        imageName = "art.scnassets/locked.png"
        modelName = "art.scnassets/Paw 4.scn"
    }
    init (petName: String, petId: Int, petImageName: String) {
        id = petId;
        name = petName;
        imageName = petImageName;
        modelName = "art.scnassets/Paw 4.scn";
    }
    
    init (petName: String, petId: Int, petImageName: String, petModelName: String) {
        id = petId;
        name = petName;
        imageName = petImageName;
        modelName = petModelName;
    }
}
