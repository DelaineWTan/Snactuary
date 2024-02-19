//
//  Updatable.swift
//  Pet Bullet Heaven
//
//  Created by Jun Solomon on 2024-02-18.
//

import Foundation

protocol Updatable {
    func Start()
    func Update(deltaTime: TimeInterval)
}
