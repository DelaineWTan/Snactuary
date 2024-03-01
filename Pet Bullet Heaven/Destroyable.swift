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

extension Destroyable where Self: SCNNode {
//    func onDestroy(after duration: TimeInterval, obj: SCNNode) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
//            self?.destroy()
//            LifecycleManager.shared.deleteGameObject()
//            self?.removeFromParentNode()
//        }
//    }
//    
//    private func destroy() {
//        onDestroy?()
//    }
}
