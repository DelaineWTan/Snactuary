//
//  GameViewController.swift
//  Pet Bullet Heaven
//
//  Created by Delaine on 2024-02-05.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewControllerMerged: UIViewController, SCNPhysicsContactDelegate {
    let overlayView = GameUIView()
    // Camera node
    let cameraNode = SCNNode()
    
    // categories for object types
    let playerCategory: Int = 1
    let foodCategory: Int = 2
    
    var playerNode: SCNNode?
    var stageNode: SCNNode?
    
    var isMoving = false
    var touchDestination: CGPoint? = nil
    
    // radius for the joystick input
    var joyStickClampedDistance: CGFloat = 100

    var score = 0
    let scoreLabel = UILabel(frame: CGRect(x: 20, y: 20, width: 100, height: 50))
    
    // create a new scene
    let scene = SCNScene(named: "art.scnassets/main.scn")!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            await Start()
        }
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        scene.physicsWorld.contactDelegate = self
        
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
        
        // Create a physics body
        let playerPhysicsBody = SCNPhysicsBody(type: .dynamic, shape: nil) // Create a dynamic physics body
        playerPhysicsBody.mass = 1.0 // Set the mass of the physics body
        playerPhysicsBody.isAffectedByGravity = false
        
        // get player
//        playerNode = scene.rootNode.childNode(withName: "mainPlayer", recursively: true)
//        playerNode?.physicsBody = playerPhysicsBody
//        
//        playerNode?.physicsBody?.categoryBitMask = playerCategory
//        playerNode?.physicsBody?.categoryBitMask = playerCategory
//        playerNode?.physicsBody?.collisionBitMask = -1
//        playerNode?.physicsBody?.contactTestBitMask = 1
        
        // get stage plane
        stageNode = scene.rootNode.childNode(withName: "plane", recursively: true)
        
        // gives warning, will fix later -Jun
        var foodSpawner = FoodSpawner(scene: scene)
        
        scoreLabel.text = "Score: \(score)"
        scoreLabel.font = UIFont.systemFont(ofSize: 20)
        scoreLabel.textColor = .white
        view.addSubview(scoreLabel)
        
        let testAbility = OrbitingProjectileAbility(_InputAbilityDamage: 1, _InputAbilityDuration: 20, _InputRotationSpeed: 10, _InputDistanceFromCenter: 3, _InputNumProjectiles: 3)
        testAbility.ActivateAbility()
        
        // Tentative, add to rootNode. Add to player in order to see Ability
        scnView.scene!.rootNode.addChildNode(testAbility)
        
        
    }
    
    // Update score and destroy food on collision
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let nodeA = contact.nodeA
        let nodeB = contact.nodeB
        
        print("Collision Begin")
        
        // Check if player collides with food or vice versa
        if (nodeA.physicsBody?.categoryBitMask == playerCategory && nodeB.physicsBody?.categoryBitMask == foodCategory)
        {
            print("Destroying food")
            nodeB.removeFromParentNode()
            score += 1
        }
        else if(nodeA.physicsBody?.categoryBitMask == foodCategory &&            nodeB.physicsBody?.categoryBitMask == playerCategory) {
            print("Destroying food")
            nodeA.removeFromParentNode()
            score += 1
            DispatchQueue.main.async {
                self.scoreLabel.text = "Score: \(self.score)"
            }
        }
    }
    
    func Start() async {
        
        await Update()
    }
    
    var count = 0
    
    // Your 'Update()' function
    @MainActor
    func Update() async {
        // code logic here
        //print("counter: \(count)")
        //count += 1
        // Repeat increment 'reanimate()' every 1/60 of a second (60 frames per second)
        try! await Task.sleep(nanoseconds: 1_000_000_000 / 60)
        await Update()
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
