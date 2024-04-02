//
//  Map.swift
//  Pet Bullet Heaven
//
//  Created by Delaine Tan on 2024-02-29.
//
import SceneKit

class Map : MonoBehaviour {
    var uniqueID: UUID
    
    var onDestroy: (() -> Void)?
    
    func onDestroy(after duration: TimeInterval) {
        // code
    }
    
    var stageNode: SCNNode?
    var playerNode: SCNNode?
    
    init(stageNode: SCNNode, playerNode: SCNNode) {
        self.stageNode = stageNode
        self.playerNode = playerNode
        self.uniqueID = UUID()
        LifecycleManager.Instance.addGameObject(self)
    }
    
    func Start() {
    }
    
    func Update() {
        scrollStage()
    }
    
    
    func scrollStage() {
        if (!Globals.playerIsMoving)
        {
            return
        }
        guard let playerNode = self.playerNode, let stageNode = self.stageNode else {
            return
        }
        
        // Manually input the stage size
        let stageX: Float = 1000
        let stageZ: Float = 1000
        
        // Calculate the translation vector based on player movement
        let translationVector = SCNVector3(Float(Globals.inputX) * Globals.playerMovementSpeed * Float(Globals.deltaTime), 0, Float(Globals.inputZ) * Globals.playerMovementSpeed * Float(Globals.deltaTime))
        
        // Apply the translation to the stage plane
        stageNode.position.x += translationVector.x
        stageNode.position.z += translationVector.z
        
        // Check if the player is approaching the edge of the stage
        let edgeMargin: Float = 50.0 // Adjust as needed
        
        let xDiff = stageNode.position.x - playerNode.position.x
        let zDiff = stageNode.position.z - playerNode.position.z
        
        // Too far north/south, teleport to south/north edge
        if abs(zDiff) > stageZ / 2 - edgeMargin {
            stageNode.position.z = -zDiff
        }
        // Too far east/west, teleport to west/east edge
        if abs(xDiff) > stageX / 2 - (edgeMargin * 1.5) {
            stageNode.position.x = -xDiff
        }
    }
}
