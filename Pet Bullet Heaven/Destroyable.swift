//
//  Destroyable.swift
//  Pet Bullet Heaven
//
//  Created by Jun Solomon on 2024-02-23.
//

import Foundation
import SceneKit

protocol Destroyable {
    var onDestroy: (() -> Void)? { get set }
    func onDestroy(after duration: TimeInterval, obj: SCNNode)
}

extension Destroyable where Self: AnyObject {
    func onDestroy(after duration: TimeInterval, obj: SCNNode) {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            self?.destroy()
            print("deeznuts")
        }
    }
    
    private func destroy() {
        onDestroy?()
        //self.removeFromParentNode()
    }
}
