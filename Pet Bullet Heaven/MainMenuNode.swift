//
//  MainMenuNode.swift
//  Pet Bullet Heaven
//
//  Created by Delaine on 2024-02-07.
//

import SceneKit

class MainMenuNode: SCNNode {    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let playButton = UIHelpers.createButtonNode(title: "Play", position: SCNVector3(0, 2, Constants.UIZIndex))
        let selectPetsButton = UIHelpers.createButtonNode(title: "Select Pets", position: SCNVector3(0, 0, Constants.UIZIndex))
        let exitButton = UIHelpers.createButtonNode(title: "Exit", position: SCNVector3(0, -2, Constants.UIZIndex))
        
        addChildNode(playButton)
        addChildNode(selectPetsButton)
        addChildNode(exitButton)
    }
}
