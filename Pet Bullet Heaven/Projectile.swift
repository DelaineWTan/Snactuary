//
//  Projectile.swift
//  Pet Bullet Heaven
//
//  Created by Jay Wang on 2024-02-13.
//

import Foundation
import SceneKit

class Projectile : SCNNode{
    
    // Member Variables
    var _Damage : Int = 1
    
    var _Mesh : SCNReferenceNode?
    
    func OnCollision(){
        
    }
    
    func loadFromFile(_AssetName: String, _FileType: String) -> SCNReferenceNode {
        
        // Retrieve the URL of the specified Resource
        let _URL = Bundle.main.url(forResource: _AssetName, withExtension: _FileType)
        
        // Load resource (referenced Scene file) as children of the ReferenceNode from the given URL
        let _ReferenceNode = SCNReferenceNode(url: _URL!)
        
        // Actually load the contents from the Referenced Node, into SCNReferenceNode
        _ReferenceNode?.load()
        
        _ReferenceNode?.name = _AssetName
        
        return _ReferenceNode!
        
    }
    
}
