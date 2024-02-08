//
//  PauseMenuNode.swift
//  Pet Bullet Heaven
//
//  Created by Delaine on 2024-02-07.
//

import SceneKit

class PauseMenuNode: SCNNode {
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let mainMenuButton = UIHelpers.createButtonNode(title: "Main Menu", position: SCNVector3(0, -1, Constants.UIZIndex))
        let returnButton = UIHelpers.createButtonNode(title: "Return", position: SCNVector3(0, 1, Constants.UIZIndex))
        
        addChildNode(mainMenuButton)
        addChildNode(returnButton)
    }
}
