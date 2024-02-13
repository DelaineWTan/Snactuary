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
    let overlayView = GameUIView()
    // Camera node
    let cameraNode = SCNNode()
    
    var playerNode: SCNNode?
    
    var isMoving = false
    var touchDestination: CGPoint? = nil

    // create a new scene
    let scene = SCNScene(named: "art.scnassets/test map.scn")!
    
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
                
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
        
        // add panning gesture for pet movement
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleMovementPan(_:)))
        scnView.addGestureRecognizer(panGesture)
        
        //get player
        playerNode = scene.rootNode.childNode(withName: "mainPlayer", recursively: true)
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
    
    @objc
    func handleMovementPan(_ gestureRecongnize: UIPanGestureRecognizer) {
        // Gets x, y values of pan. Does not return any when not detecting finger moving
        // Prob need to clamp it, have to create a helper method
        let scnView = self.view as! SCNView
        
        switch gestureRecongnize.state {
        case .began:
            let location = gestureRecongnize.location(in: gestureRecongnize.view)
            
            overlayView.inGameUIView.setStickPosition(location: location) 
            overlayView.inGameUIView.stickVisibilty(isVisible: true)
            
        case .changed:
            let translation = gestureRecongnize.translation(in: view)
            touchDestination = translation
            print("X = \(Float(touchDestination?.x ?? 0)), Y = \(Float(touchDestination?.y ?? 0))")
            isMoving = true
            movePlayer(xPoint: Float(touchDestination?.x ?? 0), zPoint: Float(touchDestination?.y ?? 0))
            
            // reset the translation
            gestureRecongnize.setTranslation(.zero, in: view)
            
        case .ended:
            isMoving = false
            overlayView.inGameUIView.stickVisibilty(isVisible: false)
            
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
