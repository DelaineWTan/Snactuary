//
//  Updatable.swift
//  Pet Bullet Heaven
//
//  Created by Jun Solomon on 2024-02-18.
//

import Foundation

protocol Updatable {
    var uniqueID: UUID { get set }
    func Start()
    func Update(deltaTime: TimeInterval)
}

extension Updatable {
    var uniqueID: UUID {
        get { return UUID() }
        set { }
    }
}
