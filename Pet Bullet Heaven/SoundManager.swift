import AVFoundation

class SoundManager {
    var backgroundMusicPlayers: [AVAudioPlayer] = []
    var tapSFXPlayers: [String: AVPlayer] = [:]
    var eatingSFXFileName: String = "pet-eating-sfx"
    var eatingSFXPlayers: [AVPlayer] = []
    var numPets: Int = 4
    
    init() {
        self.uniqueID = UUID()
        
        // Configure AVAudioSession
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [])
            try session.setActive(true)
        } catch {
            print("Failed to configure AVAudioSession: \(error.localizedDescription)")
        }
        setupAudio()
        preloadSoundEffects()
        preloadBackgroundMusic()
    }
    
    var uniqueID: UUID
    
    func setupAudio() {
        // Configure AVAudioSession
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [])
            try session.setActive(true)
        } catch {
            print("Failed to configure AVAudioSession: \(error.localizedDescription)")
        }
    }
    
    private func preloadBackgroundMusic() {
            let bgmFiles = ["meadow-bgm", "beach-bgm", "clouds-bgm"]
            
            for bgmFile in bgmFiles {
                if let musicURL = Bundle.main.url(forResource: bgmFile, withExtension: "wav", subdirectory: "art.scnassets/SFX") {
                    do {
                        let bgmPlayer = try AVAudioPlayer(contentsOf: musicURL)
                        bgmPlayer.numberOfLoops = -1 // Loop indefinitely
                        bgmPlayer.volume = 0.5 // Hardcode to 0.5 volume for now until volume settings exist
                        backgroundMusicPlayers.append(bgmPlayer)
                    } catch {
                        print("Error loading background music \(bgmFile): \(error.localizedDescription)")
                    }
                } else {
                    print("Background music file \(bgmFile) not found")
                }
            }
            playCurrentStageBGM()
        }
        
        func playCurrentStageBGM() {
            guard !backgroundMusicPlayers.isEmpty else {
                print("No background music loaded")
                return
            }
            
            let currentBGMIndex = (UserDefaults.standard.integer(forKey: Globals.stageCountKey)  - 1) % Globals.numStagePresets
            let nextBGMPlayer = backgroundMusicPlayers[currentBGMIndex]
            nextBGMPlayer.play()
        }
        
        func stopCurrentBGM() {
            guard !backgroundMusicPlayers.isEmpty else {
                print("No background music loaded")
                return
            }
            let currentBGMIndex = (UserDefaults.standard.integer(forKey: Globals.stageCountKey)  - 1) % Globals.numStagePresets
            let currentBGMPlayer = backgroundMusicPlayers[currentBGMIndex]
            currentBGMPlayer.stop()
        }
    
    private func preloadSoundEffects() {
        // Preload tapping SFX players
        let sfxFiles = ["cat-meow-sfx", "frog-croak-sfx", "duck-quack-sfx", "penguin-wenk-sfx"]
        
        for sfxFile in sfxFiles {
            if let sfxURL = Bundle.main.url(forResource: sfxFile, withExtension: "wav", subdirectory: "art.scnassets/SFX") {
                let petName = extractPetNameFromFile(from: sfxFile)
                let sfxPlayer = AVPlayer(url: sfxURL)
                sfxPlayer.volume = 0.5 // Hardcode to 0.5 volume for now until volume settings exist
                tapSFXPlayers[petName] = sfxPlayer
            }
        }
        
        // Preload eating SFX players
        guard let soundURL = Bundle.main.url(forResource: eatingSFXFileName, withExtension: "wav", subdirectory: "art.scnassets/SFX") else {
            print("Sound effect file '\(eatingSFXFileName)' not found")
            return
        }
        
        for _ in 0..<numPets {
            let sfxPlayer = AVPlayer(url: soundURL)
            sfxPlayer.volume = 0.1
            eatingSFXPlayers.append(sfxPlayer)
        }
        print("Sound effect '\(eatingSFXFileName)' preloaded")
    }
    
    // Extract pet name from the file name in the format "[pet-name]-..."
    private func extractPetNameFromFile(from fileName: String) -> String {
        return fileName.components(separatedBy: "-").first ?? ""
    }
    
    private func extractPetTypeFromNode(from nodeName: String) -> String {
        return nodeName.components(separatedBy: ".").first?.lowercased() ?? ""
    }
    
    func playTapSFX(_ petName: String) {
        let petType = extractPetTypeFromNode(from: petName)
        // @TODO play the correct sound based on pet type
        if let tapSFXPlayer = tapSFXPlayers[petType] {
            DispatchQueue.main.async {
                tapSFXPlayer.seek(to: .zero)
                tapSFXPlayer.play()
            }
        } else {
            print("Tap sound effect for \(petType) is not preloaded")
        }
    }
    
    func refreshEatingSFX() {
        for player in self.eatingSFXPlayers {
            if player.rate == 0 {
                player.seek(to: .zero)
                player.play()
                return
            }
        }
    }
}
