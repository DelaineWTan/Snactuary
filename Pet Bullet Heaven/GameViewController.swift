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

class GameViewController: UIViewController, SCNPhysicsContactDelegate, SceneProvider{
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
    
    // Add floating damage text
    let floatingText = FloatingText()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Start game loop for lifecycle methods
        Task {
            await StartLoop()
        }
        Globals.timeScale = 0
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        // set the scene to the view
        scnView.scene = Globals.mainScene
        
        // Set delegates
        overlayView.delegate = self
        Globals.mainScene.physicsWorld.contactDelegate = self
        
        // show statistics and debug options, remove for production
//        scnView.showsStatistics = true
//        scnView.debugOptions = [
//            SCNDebugOptions.showPhysicsShapes
//        ]
        // Initialize background music
        SoundManager.Instance.playCurrentStageBGM()
        // Add overlay view
        scnView.backgroundColor = UIColor.black
        overlayView.frame = scnView.bounds
        overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scnView.addSubview(overlayView)
        // Add floating damage text
        scnView.addSubview(floatingText)
        // Add player
        playerNode = Globals.mainScene.rootNode.childNode(withName: "mainPlayer", recursively: true)
        // Add stage node and init Map
        stageNode = Globals.mainScene.rootNode.childNode(withName: "stagePlane", recursively: true)
        stageNode?.geometry?.firstMaterial?.lightingModel = .constant
        map = Map(stageNode: stageNode!, playerNode: playerNode!)
        
        // Setup background
        let stageMat = stageNode?.geometry?.firstMaterial
        stageMat!.diffuse.contents = StageAestheticsHelper.setInitialStageImage(stageMat!)
        
        // Add gesture recognizers
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleMovementPan(_:)))
        scnView.addGestureRecognizer(panGesture)
        
        // Add attack patterns for initial active pets to game
        for petIndex in 0...((Globals.activePets.count) - 1) {
            // Add pets into scene
            let pet = Globals.pets[Globals.activePets[petIndex]]!
            Utilities.swapSceneNode(with: pet, position: petIndex)
        }
        
        // Initialize food models
        initializeFoodSCNModels()
        
        // Initialize the food spawner and load stage health multiplier immediately
        _ = FoodSpawner(scene: Globals.mainScene)
        UserDefaults.standard.set(Globals.foodHealthMultiplier, forKey: Globals.foodHealthMultiplierKey)
    }
    
    
    func initializeFoodSCNModels() {
        for foodGroup in Globals.foodGroups {
            for foodInformation in foodGroup {
                let foodAssetName = foodInformation.1.assetName
                Globals.foodSCNModels[foodAssetName] = Utilities.loadSceneModelNode(name: foodAssetName)
            }
        }
    }
    
    
    ///
    ///START OF PHYSICS STUFF (faiz)
    ///
    
    var nodeA : SCNNode? = SCNNode()
    var nodeB : SCNNode? = SCNNode()
    
    // food cooldown duration (in seconds)
    let foodHitCooldown: TimeInterval = 0.1

    // dictionary to track the cooldown time for each food item using their UUIDs
    var foodCooldowns: [UUID: TimeInterval] = [:]
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        nodeA = contact.nodeA
        nodeB = contact.nodeB
    }
    
    //DO PHYSICS
    func doPhysics() {
        // Check if player collides with food or vice versa
        if let food = checkFoodCollision() {
            // Check if the food item is not on cooldown or the cooldown has expired
            if !isFoodOnCooldown(food) {
                applyDamageToFood(food)
                startCooldown(for: food)
            }
        }
        nodeA = nil
        nodeB = nil
    }
    
    //check which node is the food node and return it
    func checkFoodCollision() -> BaseFoodNode? {
        if (nodeA?.physicsBody?.categoryBitMask == playerCategory && nodeB?.physicsBody?.categoryBitMask == foodCategory) {         //print("Other node \(nodeA?.name)")
            return nodeB as? BaseFoodNode
        } else if (nodeA?.physicsBody?.categoryBitMask == foodCategory && nodeB?.physicsBody?.categoryBitMask == playerCategory) {
            return nodeA as? BaseFoodNode
        }
        return nil
    }
    
    //check which node is the projectile or pet node and return it
    func checkPetCollision() -> SCNNode? {
        if (nodeA?.physicsBody?.categoryBitMask == playerCategory && nodeB?.physicsBody?.categoryBitMask == foodCategory) {
            return nodeA
        } else if (nodeA?.physicsBody?.categoryBitMask == foodCategory && nodeB?.physicsBody?.categoryBitMask == playerCategory) {
            return nodeB
        }
        return nil
    }
    
    //check if the collided food is currently on cooldown
    func isFoodOnCooldown(_ food: BaseFoodNode) -> Bool {
        if let lastHitTime = foodCooldowns[food.uniqueID] {
            return Date().timeIntervalSince1970 - lastHitTime < foodHitCooldown
        }
        return false
    }
    
    //start the cool down for colliding food
    func startCooldown(for food: BaseFoodNode) {
        foodCooldowns[food.uniqueID] = Date().timeIntervalSince1970
    }

    //use the ability to deal damage to the colliding food item
    func applyDamageToFood(_ food: BaseFoodNode) {
        // Convert food node's position to screen coordinates
        let scnView = self.view as! SCNView
        let foodPosition = scnView.projectPoint(food.presentation.position)
        let attackingNode = checkPetCollision()
        
        if let projectile = attackingNode as? Projectile {
            // Handle collision with a projectile node
            food._Health -= projectile._Damage
            
            //increment stats
            Globals.damageDone += projectile._Damage
            
            // Show floating damage text
            let floatingText = FloatingText()
            scnView.addSubview(floatingText)
            floatingText.showDamageText(at: CGPoint(x: CGFloat(foodPosition.x), y: CGFloat(foodPosition.y)), with: projectile._Damage)
        }
        else if let petNode = attackingNode as? Pet {
            food._Health -= Int(petNode.attack)
            Globals.damageDone += petNode.attack
            
            // Show floating damage text
            let floatingText = FloatingText()
            scnView.addSubview(floatingText)
            floatingText.showDamageText(at: CGPoint(x: CGFloat(foodPosition.x), y: CGFloat(foodPosition.y)), with: Int(petNode.attack))
        }

        // if food killed
        if food._Health <= 0 {
            overlayView.inGameUIView.addToHungerMeter(hungerValue: food.hungerValue)
            UserDefaults.standard.synchronize()
            food.Destroy(after: 0)
            SoundManager.Instance.refreshEatingSFX()
            let stageCycle = Utilities.getCurrentStageIteration()
            
            //Increment stats
            Globals.snacksEaten += 1
            Globals.totalScore += food.hungerValue

            //increase exp for all active pets
            for petIndex in 0...Globals.activePets.count - 1 {
                let pet = Globals.pets[Globals.activePets[petIndex]]!
                
                //add exp
                pet.exp += food.exp
               
                //check if pet has enough exp to level up
                if pet.hasLeveledUp(){
                    // assign exp over level up threshold to next level's exp
                    pet.levelUp(pet.petLevel+1)
                    let overflowExp = pet.exp - pet.levelUpExp
                    pet.exp = overflowExp
                    
                    // TODO: Delaine and Lukasz Make sure review level up code
//                    // Calculate new exp level up threshold
//                    pet.levelUpExp = Utilities.finalStatCalculation(stageCycle: stageCycle, baseStat: pet.levelUpExp, growth: pet.expGrowth) // change this if we want exponential growth back
//                    pet.petLevel += 1
//                    
//                    // scaling attack and speed values with pet growths
//                    pet.attack = Utilities.finalStatCalculation(stageCycle: stageCycle, baseStat: pet.attack, growth: pet.attackGrowth)
//                    pet.speed += Utilities.finalStatCalculation(stageCycle: stageCycle, baseStat: pet.speed, growth: pet.speedGrowth) / 10
//                    
//                    pet.attackPattern.damage = pet.attack
    
                    let mainPlayerNode = Globals.mainScene.rootNode.childNode(withName: "mainPlayer", recursively: true)
                    let oldAbilityNode = mainPlayerNode!.childNode(withName: Globals.petAbilityNodeName[petIndex], recursively: true)!
                    
                    let updatedAbility = oldAbilityNode as! Ability
                    updatedAbility.setDamage(pet.attack)
                    // updatedAbility.setDamage(Int(pet.attack))
                    //
                    let petPosition = scnView.projectPoint(pet.slotPosition)
                    let floatingText = FloatingText()
                    scnView.addSubview(floatingText)
                    floatingText.showLevelUpText(at: CGPoint(x: CGFloat(petPosition.x), y: CGFloat(petPosition.y)), with: Int(pet.petLevel))
                }
            }
        }
    }
    
    ///
    ///END OF PHYSICS STUFF
    ///
    
    func StartLoop() async {
        await ContinuousLoop()
    }
    
    @MainActor
    func ContinuousLoop() async {
        
        // read from thread-safe queue of to-be-deleted UUIDs
        LifecycleManager.Instance.update()
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
        SoundManager.Instance.playTapSFX(result.node.name ?? "")
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
        var speed : Float = 1
        
        for petIndex in 0...Globals.activePets.count - 1 {
            let pet = Globals.pets[Globals.activePets[petIndex]]!
            // combine the speed of all the pets
            speed += pet.speed/10
        }
        if Globals.inMainMenu {
            return
        }
        
        switch gestureRecongnize.state {
        case .began:
            Globals.playerIsMoving = true
            overlayView.inGameUIView.setStickPosition(location: location)
        case .changed:

            let x = translation.x.clamp(min: -joyStickClampedDistance, max: joyStickClampedDistance) / joyStickClampedDistance
            let z = translation.y.clamp(min: -joyStickClampedDistance, max: joyStickClampedDistance) / joyStickClampedDistance
            // Normalize xz vector so diagonal movement equals 1
            let length = sqrt(pow(x, 2) + pow(z, 2))
            Globals.inputX = x / length * CGFloat(speed)
            Globals.inputZ = z / length * CGFloat(speed)
            
            // Stick UI
            overlayView.inGameUIView.stickVisibilty(isVisible: true)
            overlayView.inGameUIView.updateStickPosition(fingerLocation: location)
        case .ended:
            Globals.playerIsMoving = false
            overlayView.inGameUIView.stickVisibilty(isVisible: false)
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
    
    

    func getSceneNode() -> SCNNode? {
        return Globals.mainScene.rootNode
    }
}

protocol SceneProvider: AnyObject {
    func getSceneNode() -> SCNNode?
}
