//
//  GameOverlayNode.swift
//  Pet Bullet Heaven
//
//  Created by Delaine on 2024-02-07.
//


import SceneKit

class GameOverlayNode: SCNNode {
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let pauseMenuButton = UIHelpers.createButtonNode(title: "Pause", position: SCNVector3(0, -8, Constants.UIZIndex))
        
        addChildNode(pauseMenuButton)
    }
}
