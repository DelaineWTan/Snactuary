//
//  GameViewController.swift
//  Pet Bullet Heaven
//
//  Created by Delaine on 2024-02-05.
//

import UIKit
import QuartzCore
import SceneKit

// categories for object types
let playerCategory: Int = 0b001
let foodCategory: Int = 0b010

class GameViewController: UIViewController, SCNPhysicsContactDelegate, SCNSceneRendererDelegate {
    let overlayView = GameUIView()
    // Camera node
    let cameraNode = SCNNode()

    var score = 0
    let scoreLabel = UILabel(frame: CGRect(x: 20, y: 20, width: 100, height: 50))
    
    override func viewDidLoad() {
        
        print("help me plox")
        
        super.viewDidLoad()
        
        let scene = SCNScene(named: "art.scnassets/faiz test map.scn")!
        //let cube = scene.rootNode.childNode(withName: "box2", recursively: true)
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        scnView.delegate = self
        
        scene.physicsWorld.contactDelegate = self
        
        let playerNode = scene.rootNode.childNode(withName: "player", recursively: true)
        let foodNode = scene.rootNode.childNode(withName: "food", recursively: true)
        
        // set the physics categories for objects
        playerNode?.physicsBody?.categoryBitMask = playerCategory
        foodNode?.physicsBody?.categoryBitMask = foodCategory
               
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        // Add overlay view
        overlayView.frame = scnView.bounds
        overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //scnView.addSubview(overlayView)
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)

       
        scoreLabel.text = "Score: \(score)"
        scoreLabel.font = UIFont.systemFont(ofSize: 20)
        scoreLabel.textColor = .white
        view.addSubview(scoreLabel)

        
    }
    
    // Update score and destroy food on collision
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let nodeA = contact.nodeA
        let nodeB = contact.nodeB
        
        // Check if player collides with food
        if (nodeA.physicsBody?.categoryBitMask == playerCategory || nodeB.physicsBody?.categoryBitMask == playerCategory) &&
            (nodeA.physicsBody?.categoryBitMask == foodCategory || nodeB.physicsBody?.categoryBitMask == foodCategory) {
            // Destroy food
            print("Destroying food")
            nodeB.removeFromParentNode()
            score += 1
            DispatchQueue.main.async {
                self.scoreLabel.text = "Score: \(self.score)"
            }
        }
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
