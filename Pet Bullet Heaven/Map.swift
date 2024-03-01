//
//  Map.swift
//  Pet Bullet Heaven
//
//  Created by Delaine Tan on 2024-02-29.
//
import SceneKit

class Map : Updatable {
    var stageNode: SCNNode?
    var playerNode: SCNNode?
    var isMoving: Bool
    var moveSpeed: Float = 200
    var xTranslation, zTranslation: Float
    
    init(stageNode: SCNNode, playerNode: SCNNode) {
        isMoving = false
        xTranslation = 0.0
        zTranslation = 0.0
        self.stageNode = stageNode
        self.playerNode = playerNode
        LifecycleManager.shared.addGameObject(self)
    }
    
    func Start() {
    }
    
    func Update(deltaTime: TimeInterval) {
        scrollStage(deltaTime)
    }
    
    func setIsMoving(_ isMoving: Bool) {
        self.isMoving = isMoving
    }
    
    func setJoystickTranslation(xTranslation: Float, zTranslation: Float) {
        self.xTranslation = xTranslation
        self.zTranslation = zTranslation
    }
    
    func scrollStage(_ deltaTime: TimeInterval) {
        if (!isMoving)
        {
            return
        }
        guard let playerNode = self.playerNode, let stageNode = self.stageNode else {
            return
        }
        // Adjust the scrolling speed as needed
        let scrollSpeed: Float = 2
        
        // Manually input the stage size
        let stageX: Float = 800
        let stageZ: Float = 800
        
        // Calculate the translation vector based on player movement
        let translationVector = SCNVector3(xTranslation * moveSpeed * Float(deltaTime), 0, zTranslation * moveSpeed * Float(deltaTime))
        
        // Apply the translation to the stage plane
        stageNode.position.x += translationVector.x
        stageNode.position.z += translationVector.z
        
        // Check if the player is approaching the edge of the stage
        let edgeMargin: Float = 40.0 // Adjust as needed
        
        let xDiff = stageNode.position.x - playerNode.position.x
        let zDiff = stageNode.position.z - playerNode.position.z
        
        // Too far north/south, teleport to south/north edge
        if abs(zDiff) > stageZ / 2 - edgeMargin {
            stageNode.position.z = -zDiff
        }
        // Too far east/west, teleport to west/east edge
        if abs(xDiff) > stageX / 2 - edgeMargin {
            stageNode.position.x = -xDiff
        }
    }
}
