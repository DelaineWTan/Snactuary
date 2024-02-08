//
//  GameViewController.swift
//  Pet Bullet Heaven
//
//  Created by Delaine on 2024-02-05.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    // This node always displays the selected pets and current stage background
    let mainGameNode = MainGameNode()
    // Main menu
    let mainMenuNode = MainMenuNode()
    // In-game overlay for normal gameplay experience
    let gameOverlayNode = GameOverlayNode()
    // In-game pause menu
    let pauseMenuNode = PauseMenuNode()
    // Pet selection user intereface
    let petSelectionNode = PetSelectionNode()
    
    
    
    // create a new scene
    let scene = SCNScene(named: "art.scnassets/ship.scn")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // show main menu node on start
        scene.rootNode.addChildNode(mainMenuNode)
        
        // node that contains all the game objects
        scene.rootNode.addChildNode(mainGameNode)
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        mainGameNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: Constants.cameraZIndex)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 20)
        mainGameNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        mainGameNode.addChildNode(ambientLightNode)
        
        // retrieve the ship node
        let ship = scene.rootNode.childNode(withName: "ship", recursively: true)!
        
        // animate the 3d object
        ship.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        
        // check that we clicked on at least one object
        guard hitResults.count > 0, let result = hitResults.first else {
            return
        }
        
        // Function to check if any ancestor node has the given name
        func hasAncestorWithName(_ node: SCNNode?, _ name: String) -> Bool {
            var currentNode = node
            
            // Iterate through the ancestors until we reach the root node
            while let ancestor = currentNode?.parent {
                if currentNode?.name == name {
                    return true
                }
                currentNode = ancestor
            }
            return false
        }
        
        // get the tapped node
        let tappedNode = result.node
        
        // Check if the tapped node or any of its ancestors match a specific name
        if hasAncestorWithName(tappedNode, "Play") {
            print("Play button tapped")
            scene.rootNode.addChildNode(gameOverlayNode);
            mainMenuNode.removeFromParentNode();
            // Perform action for play button tap
        } else if hasAncestorWithName(tappedNode, "Select Pets") {
            print("Select Pets button tapped")
            scene.rootNode.addChildNode(petSelectionNode);
            mainMenuNode.removeFromParentNode();
            // Perform action for select pets button tap
        } else if hasAncestorWithName(tappedNode, "Exit") {
            print("Exit button tapped")
            // Quit the app
            exit(0)
        } else if hasAncestorWithName(tappedNode, "Main Menu") {
            print("Main menu button tapped")
            scene.rootNode.addChildNode(mainMenuNode);
            petSelectionNode.removeFromParentNode();
            pauseMenuNode.removeFromParentNode();
            gameOverlayNode.removeFromParentNode()
        } else if hasAncestorWithName(tappedNode, "Pause") {
            print("Pause menu button tapped")
            scene.rootNode.addChildNode(pauseMenuNode);
        } else if hasAncestorWithName(tappedNode, "Return") {
            print("Return button tapped")
            pauseMenuNode.removeFromParentNode();
        }
        
        // get its material
        let material = result.node.geometry!.firstMaterial!
        

        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.5
        
        // on completion - unhighlight
        SCNTransaction.completionBlock = {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            material.emission.contents = UIColor.black
            
            SCNTransaction.commit()
        }
        
        material.emission.contents = UIColor.red
        
        SCNTransaction.commit()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

}
