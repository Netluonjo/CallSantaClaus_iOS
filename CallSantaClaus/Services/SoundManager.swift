import Foundation
import AVFoundation
import UIKit

public final class SoundManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
    public static let shared = SoundManager()
    
    private var ringtonePlayer: AVAudioPlayer?
    private var greetingPlayer: AVAudioPlayer?
    private var hapticTimer: Timer?
    
    @Published public var isPlayingGreeting: Bool = false
    @Published public var audioPower: Float = 0.5 // For audio wave visualizer
    private var meterTimer: Timer?
    
    override private init() {
        super.init()
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session setup error: \(error)")
        }
    }
    
    public func startRingtoneAndVibration() {
        stopRingtoneAndVibration()
        
        // Find ringtone in bundle or resources
        let url = Bundle.main.url(forResource: "santa_ringtone", withExtension: "wav")
            ?? Bundle.main.url(forResource: "Resources/santa_ringtone", withExtension: "wav")
        
        if let url = url {
            do {
                ringtonePlayer = try AVAudioPlayer(contentsOf: url)
                ringtonePlayer?.numberOfLoops = -1 // loop infinitely
                ringtonePlayer?.prepareToPlay()
                ringtonePlayer?.play()
            } catch {
                print("Failed to play ringtone: \(error)")
            }
        }
        
        // Start haptic vibration pattern
        hapticTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
        }
    }
    
    public func stopRingtoneAndVibration() {
        ringtonePlayer?.stop()
        ringtonePlayer = nil
        hapticTimer?.invalidate()
        hapticTimer = nil
    }
    
    public func playSantaGreeting(onFinished: (() -> Void)? = nil) {
        stopSantaGreeting()
        
        let url = Bundle.main.url(forResource: "santa_greeting", withExtension: "wav")
            ?? Bundle.main.url(forResource: "Resources/santa_greeting", withExtension: "wav")
        
        if let url = url {
            do {
                greetingPlayer = try AVAudioPlayer(contentsOf: url)
                greetingPlayer?.isMeteringEnabled = true
                greetingPlayer?.prepareToPlay()
                greetingPlayer?.play()
                isPlayingGreeting = true
                
                // Track meter for audio waveform visualizer
                meterTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                    guard let self = self, let player = self.greetingPlayer, player.isPlaying else { return }
                    player.updateMeters()
                    let avg = player.averagePower(forChannel: 0)
                    // Normalize from -160..0 dB to 0.1..1.0
                    let normalized = max(0.1, min(1.0, (avg + 50.0) / 50.0))
                    DispatchQueue.main.async {
                        self.audioPower = normalized
                    }
                }
            } catch {
                print("Failed to play greeting: \(error)")
            }
        }
    }
    
    public func stopSantaGreeting() {
        greetingPlayer?.stop()
        greetingPlayer = nil
        meterTimer?.invalidate()
        meterTimer = nil
        isPlayingGreeting = false
        audioPower = 0.5
    }
}
