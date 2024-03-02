//
//  GameViewController.swift
//  Pet Bullet Heaven
//
//  Created by Delaine on 2024-02-05.
//

import UIKit
import QuartzCore
import SceneKit
import AVFoundation

class GameViewController: UIViewController, SCNPhysicsContactDelegate{
    var backgroundMusic: AVAudioPlayer?
    let overlayView = GameUIView()
    // Camera node
    let cameraNode = SCNNode()
    
    // categories for object types
    let playerCategory: Int = 1
    let foodCategory: Int = 2
    
    var playerNode: SCNNode?
    var stageNode: SCNNode?
    var map: Map?
    
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
            await StartLoop()
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
                
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
        
        // add panning gesture for pet movement
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleMovementPan(_:)))
        scnView.addGestureRecognizer(panGesture)
        
        // get player
        playerNode = scene.rootNode.childNode(withName: "mainPlayer", recursively: true)
        
        // get stage plane
        stageNode = scene.rootNode.childNode(withName: "stagePlane", recursively: true)
        map = Map(stageNode: stageNode!, playerNode: playerNode!)
        
        let testAbility = OrbitingProjectileAbility(_InputAbilityDamage: 1, _InputAbilityDuration: 20, _InputRotationSpeed: 10, _InputDistanceFromCenter: 3, _InputNumProjectiles: 3)
        testAbility.ActivateAbility()
        
        scoreLabel.text = "Score: \(score)"
        scoreLabel.font = UIFont.systemFont(ofSize: 20)
        scoreLabel.textColor = .white
        view.addSubview(scoreLabel)
        
        _ = FoodSpawner(scene: scene)
        
        // Tentative, add to rootNode. Add to player in order to see Ability
        scnView.scene!.rootNode.addChildNode(testAbility)
        
        // Load and play background music
        if let musicURL = Bundle.main.url(forResource: "bgm", withExtension: "wav", subdirectory: "art.scnassets") {
            do {
                backgroundMusic = try AVAudioPlayer(contentsOf: musicURL)
                backgroundMusic?.numberOfLoops = -1 // Loop indefinitely
                backgroundMusic?.volume = 0.3 // Hardcode to 0.3 volume for now until volume settings exist
                backgroundMusic?.play()
            } catch {
                print("Error loading background music: \(error.localizedDescription)")
            }
        } else {
            print("Background music file not found")
        }
    }
    var nodeA : SCNNode? = SCNNode()
    var nodeB : SCNNode? = SCNNode()
    
    // Update score and destroy food on collision
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        nodeA = contact.nodeA
        nodeB = contact.nodeB
    }
    
    func doPhysics() {
        
        // Check if player collides with food or vice versa
        if (nodeA?.physicsBody?.categoryBitMask == playerCategory && nodeB?.physicsBody?.categoryBitMask == foodCategory)
        {
            nodeB?.removeFromParentNode()
            score += 1
            
        }
        else if(nodeA?.physicsBody?.categoryBitMask == foodCategory && nodeB?.physicsBody?.categoryBitMask == playerCategory)
        {
            nodeA?.removeFromParentNode()
            score += 1
            
        }
        nodeA = nil
        nodeB = nil
        DispatchQueue.main.async {
            self.scoreLabel.text = "Score: \(self.score)"
        }
    }
    
    func StartLoop() async {
        await ContinuousLoop()
    }
    
    @MainActor
    func ContinuousLoop() async {
        LifecycleManager.shared.update()
        doPhysics()
        // Repeat increment 'reanimate()' every 1/60 of a second (60 frames per second)
        try! await Task.sleep(nanoseconds: 1_000_000_000 / 60)
        await ContinuousLoop()
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
            Globals.playerIsMoving = true
            overlayView.inGameUIView.setStickPosition(location: location)
        case .changed:

            let x = translation.x.clamp(min: -joyStickClampedDistance, max: joyStickClampedDistance) / joyStickClampedDistance
            let z = translation.y.clamp(min: -joyStickClampedDistance, max: joyStickClampedDistance) / joyStickClampedDistance
            // Normalize xz vector so diagonal movement equals 1
            let length = sqrt(pow(x, 2) + pow(z, 2))
            Globals.inputX = x / length
            Globals.inputZ = z / length
            // Stick UI
            overlayView.inGameUIView.stickVisibilty(isVisible: true)
            overlayView.inGameUIView.updateStickPosition(fingerLocation: location)
        case .ended:
            Globals.playerIsMoving = false
            overlayView.inGameUIView.stickVisibilty(isVisible: false)
            // add other logic
            
        default:
            break
        }
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
