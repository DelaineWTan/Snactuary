import AVFoundation

class SoundManager {
    var backgroundMusicPlayers: [AVAudioPlayer] = []
    var tapSFXPlayer: AVPlayer?
    var eatingSFXFileName: String = "pet-eating-sfx"
    var eatingSFXPlayers: [AVPlayer] = []
    var maxEatingSFXPlayers: Int = 4
    
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
            let bgmFiles = ["meadow-bgm", "beach-bgm", "clouds-bgm"] // Names of your different BGM files
            
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
            
            var currentBGMIndex = Globals.currentStage % Globals.numStagePresets
            let nextBGMPlayer = backgroundMusicPlayers[currentBGMIndex]
            nextBGMPlayer.play()
        }
        
        func stopCurrentBGM() {
            guard !backgroundMusicPlayers.isEmpty else {
                print("No background music loaded")
                return
            }
            var currentBGMIndex = Globals.currentStage % Globals.numStagePresets
            let currentBGMPlayer = backgroundMusicPlayers[currentBGMIndex]
            currentBGMPlayer.stop()
        }
    
    private func preloadSoundEffects() {
        // Preload tap sound effect
        guard let tapSFXURL = Bundle.main.url(forResource: "quack-sfx", withExtension: "wav", subdirectory: "art.scnassets/SFX") else {
            print("Tap sound effect file 'quack-sfx' not found")
            return
        }
        
        tapSFXPlayer = AVPlayer(url: tapSFXURL)
        tapSFXPlayer!.volume = 0.5
        print("Sound effect 'quack-sfx' preloaded")
        
        guard let soundURL = Bundle.main.url(forResource: eatingSFXFileName, withExtension: "wav", subdirectory: "art.scnassets/SFX") else {
            print("Sound effect file '\(eatingSFXFileName)' not found")
            return
        }
        
        for _ in 0..<maxEatingSFXPlayers {
            let sfxPlayer = AVPlayer(url: soundURL)
            sfxPlayer.volume = 0.1
            eatingSFXPlayers.append(sfxPlayer)
        }
        print("Sound effect '\(eatingSFXFileName)' preloaded")
    }
    
    func playTapSFX() {
        // Check if tapSFXPlayer is already playing
        guard let tapSFXPlayer = self.tapSFXPlayer else {
            print("Tap sound effect is not preloaded")
            return
        }
        
        if tapSFXPlayer.rate > 0 {
            print("Tap sound effect is already playing")
            return
        }
        
        DispatchQueue.main.async {
            tapSFXPlayer.seek(to: .zero)
            tapSFXPlayer.play()
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
