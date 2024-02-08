//
//  PetSelectionNode.swift
//  Pet Bullet Heaven
//
//  Created by Delaine on 2024-02-07.
//

import SceneKit

class PetSelectionNode: SCNNode {
    let zIndex = 10
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        position = SCNVector3(0, 0, zIndex)
        
        let mainMenuButton = UIHelpers.createButtonNode(title: "Main Menu", position: SCNVector3(0, 2, 0))
        
        addChildNode(mainMenuButton)
    }
    
    
}


