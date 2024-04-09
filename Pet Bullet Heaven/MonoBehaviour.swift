//
//  Updatable.swift
//  Pet Bullet Heaven
//
//  Created by Jun Solomon on 2024-02-18.
//

import Foundation
import SceneKit

protocol MonoBehaviour {
    var uniqueID: UUID { get set }
    func Start()
    func Update()
    var onDestroy: (() -> Void)? { get set }
    func onDestroy(after duration: TimeInterval)
}

extension MonoBehaviour where Self: SCNNode {
    
    func onDestroy(after duration: TimeInterval = 0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            self?.destroy()
            if let self = self {
                LifecycleManager.Instance.deleteGameObject(gameObject: self)
                self.removeFromParentNode()
                self.childNodes.forEach { $0.removeFromParentNode()}
            }
        }
    }
    
    private func destroy() {
        onDestroy?()
    }
}
