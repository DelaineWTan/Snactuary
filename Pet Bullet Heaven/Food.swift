//
//  Food.swift
//  Pet Bullet Heaven
//
//  Created by Jun Solomon on 2024-02-14.
//

import Foundation
import SceneKit

///
/// Rudimentary Food Class
///
class Food : SCNNode {
    
    var _Health : Int = 1
    
    var _Mesh : SCNBox?
    
    override init() {
        super.init()
        
        let cubeGeometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
        
        let cubeNode = SCNNode(geometry: cubeGeometry)
        
        // will be changed to whatever the model is
        cubeNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/goldblock.png")
        
        // not sure if we put it here or in gameviewcontroller
        cubeNode.position = SCNVector3(0, 0.5, 0)
        
        let angleInDegrees: Float = 45.0
        let angleInRadians = angleInDegrees * .pi / 180.0
        cubeNode.eulerAngles = SCNVector3(0, angleInRadians, 0)
        self.addChildNode(cubeNode)
        
        self._Mesh = cubeGeometry
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
