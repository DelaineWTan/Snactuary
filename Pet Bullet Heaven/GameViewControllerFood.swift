//
//  GameViewController.swift
//  Pet Bullet Heaven
//
//  Created by Delaine on 2024-02-05.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewControllerFood: UIViewController {
    let overlayView = GameUIView()
    // Camera node
    let cameraNode = SCNNode()
    
    var playerNode: SCNNode?
    var stageNode: SCNNode?
    
    var isMoving = false
    var touchDestination: CGPoint? = nil
    
    // radius for the joystick input
    var joyStickClampedDistance: CGFloat = 100

    // create a new scene
    let scene = SCNScene(named: "art.scnassets/food functionality.scn")!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        // Add overlay view
        overlayView.frame = scnView.bounds
        overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scnView.addSubview(overlayView)
        // add self rendering every frame logic
                
        //scnView.allowsCameraControl = true
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
        
        // add panning gesture for pet movement
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleMovementPan(_:)))
        scnView.addGestureRecognizer(panGesture)
        
        // get player
        playerNode = scene.rootNode.childNode(withName: "mainPlayer", recursively: true)
        
        // get stage plane
        stageNode = scene.rootNode.childNode(withName: "plane", recursively: true)
        
        
        var foodSpawner = FoodSpawner(scene: scene)
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
    
    var intialCenter = CGPoint()
    
    @objc
    func handleMovementPan(_ gestureRecongnize: UIPanGestureRecognizer) {
        // Gets x, y values of pan. Does not return any when not detecting finger moving
        // Prob need to clamp it, have to create a helper method
        let translation = gestureRecongnize.translation(in: view)
        let location = gestureRecongnize.location(in: view)
        
        switch gestureRecongnize.state {
        case .began:
            isMoving = true
            Globals.playerIsMoving = isMoving
            overlayView.inGameUIView.setStickPosition(location: location)
        case .changed:

            let x = translation.x.clamp(min: -joyStickClampedDistance, max: joyStickClampedDistance) / joyStickClampedDistance
            let z = translation.y.clamp(min: -joyStickClampedDistance, max: joyStickClampedDistance) / joyStickClampedDistance

            Globals.rawInputX = x
            Globals.rawInputZ = z
            movePlayer(xPoint: Float(x), zPoint: Float(z)) // decouple later
            
            // Stick UI
            overlayView.inGameUIView.stickVisibilty(isVisible: true)
            overlayView.inGameUIView.updateStickPosition(fingerLocation: location)
        case .ended:
            isMoving = false
            Globals.playerIsMoving = isMoving
            overlayView.inGameUIView.stickVisibilty(isVisible: false)
            // add other logic
            
        default:
            break
        }
    }
    
    // "Moves" the player by moving everything else (stage, food etc) the opposite direction in order to keep the player at origin 0,0,0
    func movePlayer(xPoint: Float, zPoint: Float) {
        // Call the function to scroll the stage based on player movement
        scrollStage(xTranslation: xPoint, zTranslation: zPoint)
    }

    // Function to scroll the stage plane based on player movement and create the illusion of infinite scrolling
    func scrollStage(xTranslation: Float, zTranslation: Float) {
        // Get the current position of the stage plane
        guard let stageNode = stageNode, let playerNode = playerNode else {
            return
        }
        
        // Adjust the scrolling speed as needed
        let scrollSpeed: Float = 1
        
        // Manually input the stage size
        let stageX: Float = 100 // Adjust as needed
        let stageZ: Float = 100 // Adjust as needed
        
        // Calculate the translation vector based on player movement
        let translationVector = SCNVector3(xTranslation * scrollSpeed, 0, zTranslation * scrollSpeed)
        
        // Apply the translation to the stage plane
        stageNode.position.x += translationVector.x
        stageNode.position.z += translationVector.z
        
        // Check if the player is approaching the edge of the stage
        let edgeMargin: Float = 20.0 // Adjust as needed
        
        if abs(stageNode.position.x - playerNode.position.x) > stageX / 2 - edgeMargin {
            // If the player is close to the edge, shift the stage in the opposite direction to create the illusion of infinite scrolling
            
            stageNode.position.x = playerNode.position.x
        }
        
        if abs(stageNode.position.z - playerNode.position.z) > stageZ / 2 - edgeMargin {
            // If the player is close to the edge, shift the stage in the opposite direction to create the illusion of infinite scrolling
            
            stageNode.position.z = playerNode.position.z
        }
    }



    
    func stopPlayer() {
        isMoving = false
        // add other logic here (like stopping sound or animation
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
