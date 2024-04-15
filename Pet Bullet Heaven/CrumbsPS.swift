import SceneKit

class CrumbsPS : SCNNode, MonoBehaviour {
    var uniqueID: UUID
    var particleSystem: SCNParticleSystem
    func Start() {
    }
    
    func Update() {
        if Globals.playerIsMoving {
            let translationVector = SCNVector3(Float(Globals.inputX) * Globals.playerMovementSpeed * Float(Globals.deltaTime), 0, Float(Globals.inputZ) * Globals.playerMovementSpeed * Float(Globals.deltaTime))

            self.position.x += translationVector.x
            self.position.z += translationVector.z
        }
    }
    
    func OnDestroy() {
        
    }
    
    var DestroyExtras: (() -> Void)?
    
    init(_ position: SCNVector3) {
        self.uniqueID = UUID()
        let node:SCNNode = (Globals.mainScene.rootNode.childNode(withName: "Crumbs", recursively: true)!)
        particleSystem = (node.particleSystems?.first)!
        particleSystem.particleColor = .yellow
        particleSystem.emitterShape = SCNSphere(radius: 0.5)
        super.init()
        self.addParticleSystem(particleSystem)
        self.position = position
        Globals.mainScene.rootNode.addChildNode(self)
        LifecycleManager.Instance.addGameObject(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
