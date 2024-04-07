//
//  GoblinFoodNode.swift
//  Pet Bullet Heaven
//
//  Created by Jun Solomon on 2024-04-07.
//

import Foundation
import SceneKit

public class GoblinFoodNode: BaseFoodNode {
    
    override init(spawnLocation: SCNVector3, foodData: FoodData) {
        super.init(spawnLocation: spawnLocation, foodData: foodData)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func doBehaviour() {
        super.doBehaviour()
    }
}
