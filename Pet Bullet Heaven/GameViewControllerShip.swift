import UIKit
import QuartzCore
import SceneKit

class GameViewControllerShip: UIViewController {
    let overlayView = GameUIView()
    // Camera node
    let cameraNode = SCNNode()
    
    var playerNode: SCNNode?
    var stageNode: SCNNode?
    
    var isMoving = false
    var touchDestination: CGPoint? = nil
    
    // radius for the joystick input
    var joyStickClampedDistance: CGFloat = 100

    // create a new scene
    let scene = SCNScene(named: "art.scnassets/ship.scn")!
    
    
    
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
        
            
        scnView.allowsCameraControl = true

        
        // Usage example:
        let planeGeometry = createPlaneGeometry(width: 50.0, height: 50.0, widthSegments: 500, heightSegments: 500)
        let planeNode = SCNNode(geometry: planeGeometry)
        planeNode.eulerAngles.x = .pi / -2
        scene.rootNode.addChildNode(planeNode)
        
        // get player
        let ship = scene.rootNode.childNode(withName: "ship", recursively: true)
        //ship?.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        
        let shipMaterial = ship?.childNodes[0].geometry?.firstMaterial
        let program = SCNProgram()
        program.vertexFunctionName = "cloudVertex"
        program.fragmentFunctionName = "cloudFragment"
        shipMaterial?.program = program

        let image = UIImage(named: "art.scnassets/perlinmap")
        let imageProperty = SCNMaterialProperty(contents: image)
        // The name you supply here should match the texture parameter name in the fragment shader
        shipMaterial?.setValue(imageProperty, forKey: "diffuseTexture")
        
        //let plane = scene.rootNode.childNode(withName: "floor", recursively: true)
        planeNode.geometry?.firstMaterial?.program = program
        //plane?.geometry?.firstMaterial?.setValue(imageProperty, forKey: "diffuseTexture")
        let geosphere = scene.rootNode.childNode(withName: "geosphere", recursively: true)
        geosphere?.geometry?.firstMaterial?.program = program
        let sphere = scene.rootNode.childNode(withName: "sphere", recursively: true)
        sphere?.geometry?.firstMaterial?.program = program
    }


    func createPlaneGeometry(width: CGFloat, height: CGFloat, widthSegments: Int, heightSegments: Int) -> SCNGeometry {
        // Calculate the size of each segment
        let segmentWidth = width / CGFloat(widthSegments)
        let segmentHeight = height / CGFloat(heightSegments)
        
        // Create arrays to hold the vertices, normals, texture coordinates, and indices
        var vertices: [SCNVector3] = []
        var normals: [SCNVector3] = [] // Add normals array
        var texCoords: [CGPoint] = []
        var indices: [Int32] = []
        
        // Generate vertices, normals, and texture coordinates
        for y in 0...heightSegments {
            for x in 0...widthSegments {
                let vertex = SCNVector3(CGFloat(x) * segmentWidth, CGFloat(y) * segmentHeight, 0.0)
                let normal = SCNVector3(0.0, 0.0, 1.0) // Default normal (e.g., pointing in positive z-direction)
                let texCoord = CGPoint(x: CGFloat(x) / CGFloat(widthSegments), y: CGFloat(y) / CGFloat(heightSegments))
                vertices.append(vertex)
                normals.append(normal)
                texCoords.append(texCoord)
            }
        }
        
        // Generate indices
        for y in 0..<heightSegments {
            for x in 0..<widthSegments {
                let startIndex = Int32(y * (widthSegments + 1) + x)
                let nextRowStartIndex = startIndex + Int32(widthSegments) + 1
                indices.append(startIndex)
                indices.append(startIndex + 1)
                indices.append(nextRowStartIndex)
                indices.append(startIndex + 1)
                indices.append(nextRowStartIndex + 1)
                indices.append(nextRowStartIndex)
            }
        }
        
        // Create geometry sources for vertices, normals, and texture coordinates
        let vertexSource = SCNGeometrySource(vertices: vertices)
        let normalSource = SCNGeometrySource(normals: normals) // Create geometry source for normals
        let texCoordSource = SCNGeometrySource(textureCoordinates: texCoords)
        
        // Create geometry element for indices
        let element = SCNGeometryElement(indices: indices, primitiveType: .triangles)
        
        // Create geometry
        let geometry = SCNGeometry(sources: [vertexSource, normalSource, texCoordSource], elements: [element]) // Include normal source
        
        return geometry
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
