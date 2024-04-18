//
//  Updatable.swift
//  Pet Bullet Heaven
//
//  Created by Jun Solomon on 2024-02-18.
//

import Foundation
import SceneKit

/// Protocol defining behavior for objects that can be updated and destroyed
/// Difference between the monobehaviour from Unity and this is that here it is a protocol/interface
/// rather than a class you inherit from.
///
/// "Mom, can we get MonoBehaviour?"
/// "We have MonoBehaviour at home"
/// MonoBehaviour at home:
protocol MonoBehaviour {
    var uniqueID: UUID { get set }
    func Start()
    func Update()
    func OnDestroy()	
    var DestroyExtras: (() -> Void)? { get set }
    func Destroy(after duration: TimeInterval)
}

// TBH could've done the Destroy functionality and architecture better
extension MonoBehaviour where Self: SCNNode {
    // Default implementation of Destroy method to asynchronously destroy the object
    func Destroy(after duration: TimeInterval = 0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            self?.destroy()
            if let self = self {
                LifecycleManager.Instance.deleteGameObject(gameObject: self)
                self.geometry?.firstMaterial?.normal.contents = nil
                self.geometry?.firstMaterial?.diffuse.contents = nil
                self.removeFromParentNode()
                self.childNodes.forEach { $0.removeFromParentNode()}
            }
        }
    }

    // Internal method to execute additional destruction logic
    private func destroy() {
        DestroyExtras?()
    }
}
