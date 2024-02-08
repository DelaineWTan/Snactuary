//
//  MainGameNode.swift
//  Pet Bullet Heaven
//
//  Created by Delaine on 2024-02-07.
//

import SceneKit

class MainGameNode: SCNNode {
    override init() {
        super.init()
        //setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var scene1 = SCNScene()
    
    public func setup(scene: SCNScene) {
        scene1 = scene
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        addChildNode(ambientLightNode)
        
        // retrieve the ship node
        //let ship = scene.rootNode.childNode(withName: "ship", recursively: true)!
        
        addCube1()
        // animate the 3d object
        //ship.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
    }
    
    // Create Cube
    func addCube1() {
        let theCube = SCNNode(geometry: SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)) // Create a object node of box shape with width of 1 and height of 1
        theCube.name = "The Cube" // Name the node so we can reference it later
        let materials = [UIColor.red, UIColor.green, UIColor.blue, UIColor.yellow, UIColor.cyan, UIColor.magenta] // List of materials for each side
        theCube.geometry?.firstMaterial?.diffuse.contents = materials[0] // Diffuse the red colour material across the whole cube
        
        var nextMaterial: SCNMaterial // Initialize temporary variable to store each texture
        
        for index in 1...5 {
            nextMaterial = SCNMaterial() // Empty the variable
            nextMaterial.diffuse.contents = materials[index] // Set the material of the temporary variable to the material at index 1 in the list
            theCube.geometry?.insertMaterial(nextMaterial, at: index) // Set the side of the cube at index 1 to the material stored in the temporary variable
        }
        
        theCube.position = SCNVector3(0, 0, 0) // Put the cube at position (0, 0, 0)
        rootNode.addChildNode(theCube) // Add the cube node to the scene
    }
}

