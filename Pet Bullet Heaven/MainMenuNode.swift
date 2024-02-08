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
        position = SCNVector3(0, 0, zIndex) // Adjust position as needed
        
        // Create and add buttons
        let button1 = createButton(title: "Play", position: SCNVector3(0, 2, 0))
        let button2 = createButton(title: "Select Pets", position: SCNVector3(0, 0, 0))
        let button3 = createButton(title: "Exit", position: SCNVector3(0, -2, 0))
        
        addChildNode(button1)
        addChildNode(button2)
        addChildNode(button3)
    }
    
    private func createButton(title: String, position: SCNVector3) -> SCNNode {
        // Customize button appearance
        let buttonGeometry = SCNBox(width: 3, height: 1, length: 0.1, chamferRadius: 0.2)
        let buttonMaterial = SCNMaterial()
        buttonMaterial.diffuse.contents = UIColor.blue
        buttonGeometry.materials = [buttonMaterial]
        
        // Create button node
        let buttonNode = SCNNode(geometry: buttonGeometry)
        buttonNode.position = position
        // Assign custom name based on button title
        buttonNode.name = title
        
        // Add text label to button
        let textGeometry = SCNText(string: title, extrusionDepth: 0.1)
        textGeometry.font = UIFont.systemFont(ofSize: 0.2)
        let textMaterial = SCNMaterial()
        textMaterial.diffuse.contents = UIColor.white
        textGeometry.materials = [textMaterial]
        
        // Calculate text size
        let (min, max) = textGeometry.boundingBox

        // Create text node
        let textNode = SCNNode(geometry: textGeometry)
        let dx = Float(min.x - max.x)
        // @TODO find out why we need this -2 offset, seems arbitrary but it aligns the
        // text perfectly
        let dy = -2 + Float(min.y - max.y)/2.0
        //textNode.position = SCNVector3(-textWidth, -textHeight/2, 0)
        textNode.position = SCNVector3(dx, dy, 0)
        textNode.scale = SCNVector3(2, 2, 2) // Adjust text scale
        buttonNode.addChildNode(textNode)
        
        categoryBitMask
        
        return buttonNode
    }
}
