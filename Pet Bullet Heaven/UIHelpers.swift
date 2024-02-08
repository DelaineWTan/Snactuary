//
//  UIHelpers.swift
//  Pet Bullet Heaven
//
//  Created by Delaine on 2024-02-07.
//

import SceneKit
import UIKit

public class UIHelpers {
    public static func createButtonNode(title: String, position: SCNVector3) -> SCNNode {
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
            let textNode = createTextNode(title: title)
            buttonNode.addChildNode(textNode)
            
            return buttonNode
        }
        
        private static func createTextNode(title: String) -> SCNNode {
            // Create text geometry for the button title
            let textGeometry = SCNText(string: title, extrusionDepth: 0.1)
            textGeometry.font = UIFont.systemFont(ofSize: 0.2)
            textGeometry.alignmentMode = CATextLayerAlignmentMode.center.rawValue
            
            // Create a material for the text
            let textMaterial = SCNMaterial()
            textMaterial.diffuse.contents = UIColor.white
            textGeometry.materials = [textMaterial]
            
            // Create a node with the text geometry
            let textNode = SCNNode(geometry: textGeometry)
            
            // Calculate text size
            let (min, max) = textGeometry.boundingBox
            let dx = Float(min.x - max.x)
            // @TODO Identify why this mysterious -2 constant centers the button text
            let dy = -2 + Float(min.y - max.y) / 2.0
            textNode.position = SCNVector3(dx, dy, 0)
            textNode.scale = SCNVector3(2, 2, 2) // Adjust text scale
            
            return textNode
        }
}

