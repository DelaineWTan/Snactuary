//
//  MainMenuNode.swift
//  Pet Bullet Heaven
//
//  Created by Delaine on 2024-02-07.
//

import SceneKit

class MainMenuNode: SCNNode {
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
        
        // Create and add buttons
        let button1 = UIHelpers.createButtonNode(title: "Play", position: SCNVector3(0, 2, 0))
        let button2 = UIHelpers.createButtonNode(title: "Select Pets", position: SCNVector3(0, 0, 0))
        let button3 = UIHelpers.createButtonNode(title: "Exit", position: SCNVector3(0, -2, 0))
        
        addChildNode(button1)
        addChildNode(button2)
        addChildNode(button3)
    }
}
