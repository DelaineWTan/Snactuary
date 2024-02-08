//
//  GameViewController.swift
//  Pet Bullet Heaven
//
//  Created by Delaine on 2024-02-05.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController, SCNSceneRendererDelegate {
    
    var playerNode: SCNNode?
    
    var isMoving = false
    var touchDestination: CGPoint? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
    
        
        // show main menu node on start
        let mainMenuNode = MainMenuNode()
        scene.rootNode.addChildNode(mainMenuNode)
        
        // node that contains all the game objects
        let gameNode = MainGameNode()
        scene.rootNode.addChildNode(gameNode)
        
        // node for pet selection
        let petSelectionNode = PetSelectionNode()
        scene.rootNode.addChildNode(petSelectionNode)
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        gameNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 30)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        gameNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        gameNode.addChildNode(ambientLightNode)
        
        // retrieve the ship node
        let ship = scene.rootNode.childNode(withName: "ship", recursively: true)!
        playerNode = ship
        
        // animate the 3d object
        ship.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        //scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        // add self rendering every frame logic
        scnView.delegate = self
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
        
        // add panning gesture for pet movement
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleMovementPan(_:)))
        scnView.addGestureRecognizer(panGesture)
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result = hitResults[0]
            
            // get its material
            let material = result.node.geometry!.firstMaterial!
            
            // highlight it
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
    }
    
    @objc
    func handleMovementPan(_ gestureRecongnize: UIPanGestureRecognizer) {
        switch gestureRecongnize.state {
        case .changed:
            print("enter .changed")
            let translation = gestureRecongnize.translation(in: view)
            touchDestination = translation
            isMoving = true
            
            // reset the translation
            gestureRecongnize.setTranslation(.zero, in: view)
            
        case .ended:
            stopPlayer()
            
        default:
            break
        }
    }
    
    func movePlayer(xPoint: Float, zPoint: Float) {
        // Prob need to clamp it, have to create a helper method
        playerNode?.position.x += xPoint
        playerNode?.position.y -= zPoint //change to z coordinate later after testing
    }
    
    func stopPlayer() {
        isMoving = false
        // add other logic here (like stopping sound or animation
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if (isMoving) {
            movePlayer(xPoint: Float(touchDestination?.x ?? 0), zPoint: Float(touchDestination?.y ?? 0))
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
