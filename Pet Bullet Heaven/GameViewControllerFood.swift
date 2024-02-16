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
        
        // For moving camera inside the game
        scnView.allowsCameraControl = true
                
        // add a tap gesture recognizer
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        //scnView.addGestureRecognizer(tapGesture)
        
        // add panning gesture for pet movement
        //let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleMovementPan(_:)))
        //scnView.addGestureRecognizer(panGesture)
        
        //get player
        playerNode = scene.rootNode.childNode(withName: "mainPlayer", recursively: true)
        
        let positions: [SCNVector3] = [
            SCNVector3(x: 10, y: 0, z: 0),
//            SCNVector3(x: -10, y: 0, z: 0),
//            SCNVector3(x: 0, y: 0, z: 10),
//            SCNVector3(x: 0, y: 0, z: -10),
        ]
        
        var foodSpawner = FoodSpawner(scene: scene, spawnPositions: positions)
        //let food = Food()
        
        //food.eulerAngles = SCNVector3(0, 90, 0)
        //scene.rootNode.addChildNode(food)
        
        
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
            overlayView.inGameUIView.setStickPosition(location: location)
        case .changed:

            let x = translation.x.clamp(min: -joyStickClampedDistance, max: joyStickClampedDistance) / joyStickClampedDistance
            let z = translation.y.clamp(min: -joyStickClampedDistance, max: joyStickClampedDistance) / joyStickClampedDistance
            print("(\(x), \(z))")
            movePlayer(xPoint: Float(x), zPoint: Float(z)) // decouple later
            
            // Stick UI
            overlayView.inGameUIView.stickVisibilty(isVisible: true)
            overlayView.inGameUIView.updateStickPosition(fingerLocation: location)
        case .ended:
            isMoving = false
            overlayView.inGameUIView.stickVisibilty(isVisible: false)
            // add other logic
            
        default:
            break
        }
    }
    
    func movePlayer(xPoint: Float, zPoint: Float) {
        playerNode?.position.x -= xPoint
        playerNode?.position.z -= zPoint //change to z coordinate
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
