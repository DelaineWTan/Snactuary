//
//  Map.swift
//  Pet Bullet Heaven
//
//  Created by Delaine Tan on 2024-02-29.
//
import SceneKit

class MapNode : SCNNode, Updatable {
    var playerNode: SCNNode?
    var isMoving: Bool
    var moveSpeed = 1.0;
    var xTranslation, zTranslation: Float
    
    init(playerNode: SCNNode) {
        isMoving = false
        xTranslation = 0.0
        zTranslation = 0.0
        super.init()
        self.playerNode = playerNode
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func Start() {
    }
    
    func Update(deltaTime: TimeInterval) {
        scrollStage()
        print(deltaTime )
    }
    
    func setIsMoving(_ isMoving: Bool) {
        self.isMoving = isMoving
    }
    
    func setJoystickTranslation(xTranslation: Float, zTranslation: Float) {
        self.xTranslation = xTranslation
        self.zTranslation = zTranslation
    }
    
    func scrollStage() {
        guard let playerNode = self.playerNode else {
            return
        }
        // Adjust the scrolling speed as needed
        let scrollSpeed: Float = 2
        
        // Manually input the stage size
        let stageX: Float = 800
        let stageZ: Float = 800
        
        // Calculate the translation vector based on player movement
        let translationVector = SCNVector3(xTranslation * scrollSpeed, 0, zTranslation * scrollSpeed)
        
        // Apply the translation to the stage plane
        self.position.x += translationVector.x
        self.position.z += translationVector.z
        
        // Check if the player is approaching the edge of the stage
        let edgeMargin: Float = 40.0 // Adjust as needed
        
        let xDiff = self.position.x - playerNode.position.x
        let zDiff = self.position.z - playerNode.position.z
        
        // Too far north/south, teleport to south/north edge
        if abs(zDiff) > stageZ / 2 - edgeMargin {
            self.position.z = -zDiff
        }
        // Too far east/west, teleport to west/east edge
        if abs(xDiff) > stageX / 2 - edgeMargin {
            self.position.x = -xDiff
        }
    }
}
