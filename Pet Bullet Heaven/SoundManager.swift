//
//  SoundManager.swift
//  Pet Bullet Heaven
//
//  Created by Delaine on 2024-03-04.
//

import AVFoundation

class SoundManager : MonoBehaviour {
    var backgroundMusic: AVAudioPlayer?
    var tapSFXPlayer: AVAudioPlayer?
    var sfxPlayers: [AVAudioPlayer] = []
    
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
    
    func playTapSFX(named fileName: String) {
        guard let tapSFXURL = Bundle.main.url(forResource: fileName, withExtension: "wav", subdirectory: "art.scnassets") else {
            print("Tap sound effect file not found")
            return
        }
        
        // Check if tapSFXPlayer is already playing
        if let tapSFXPlayer = self.tapSFXPlayer, tapSFXPlayer.isPlaying {
            print("Tap sound effect is already playing")
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                self.tapSFXPlayer = try AVAudioPlayer(contentsOf: tapSFXURL)
                self.tapSFXPlayer?.volume = 0.5 // Adjust volume as needed
                self.tapSFXPlayer?.prepareToPlay()
                self.tapSFXPlayer?.play()
            } catch {
                print("Error playing tap sound effect: \(error.localizedDescription)")
            }
        }
    }
    
    
    func playSoundEffect(named fileName: String) {
        guard let soundURL = Bundle.main.url(forResource: fileName, withExtension: "wav", subdirectory: "art.scnassets") else {
            print("Sound effect file '\(fileName)' not found")
            return
        }
        
        do {
            let sfxPlayer = try AVAudioPlayer(contentsOf: soundURL)
            sfxPlayer.volume = 0.5 // Adjust volume as needed
            sfxPlayer.play()
            print("playSoundEffect played")
            sfxPlayers.append(sfxPlayer)
        } catch {
            print("Error playing sound effect '\(fileName)': \(error.localizedDescription)")
        }
    }
    
    func Update(deltaTime: TimeInterval) {
        // Check for completion of sound effects and remove them from the list
        sfxPlayers = sfxPlayers.filter { $0.isPlaying }
    }
    
    var onDestroy: (() -> Void)?
    
    func onDestroy(after duration: TimeInterval) {
    }
}
