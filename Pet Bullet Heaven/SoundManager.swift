//
//  SoundManager.swift
//  Pet Bullet Heaven
//
//  Created by Delaine on 2024-03-04.
//

import AVFoundation

class SoundManager : MonoBehaviour {
    var backgroundMusic: AVAudioPlayer?
    
    init() {
        self.uniqueID = UUID()
        LifecycleManager.shared.addGameObject(self)
    }
    
    var uniqueID: UUID
    
    func Start() {
        // Load and play background music
        if let musicURL = Bundle.main.url(forResource: "bgm", withExtension: "wav", subdirectory: "art.scnassets") {
            do {
                backgroundMusic = try AVAudioPlayer(contentsOf: musicURL)
                backgroundMusic?.numberOfLoops = -1 // Loop indefinitely
                backgroundMusic?.volume = 0.3 // Hardcode to 0.3 volume for now until volume settings exist
                backgroundMusic?.play()
            } catch {
                print("Error loading background music: \(error.localizedDescription)")
            }
        } else {
            print("Background music file not found")
        }
    }
    
    func Update(deltaTime: TimeInterval) {
    }
    
    var onDestroy: (() -> Void)?
    
    func onDestroy(after duration: TimeInterval) {
    }
}
