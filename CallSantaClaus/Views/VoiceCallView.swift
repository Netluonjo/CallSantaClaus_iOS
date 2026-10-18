import SwiftUI

public struct VoiceCallView: View {
    public let childName: String
    public let onEndCall: () -> Void
    public let onSwitchToVideo: () -> Void
    
    @State private var callDurationSeconds: Int = 0
    @State private var isMuted: Bool = false
    @State private var isSpeakerOn: Bool = true
    @State private var avatarPulsing: CGFloat = 1.0
    
    private let callTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    public init(
        childName: String,
        onEndCall: @escaping () -> Void,
        onSwitchToVideo: @escaping () -> Void
    ) {
        self.childName = childName
        self.onEndCall = onEndCall
        self.onSwitchToVideo = onSwitchToVideo
    }
    
    public var body: some View {
        ZStack {
            ChristmasTheme.backgroundGradient
                .ignoresSafeArea()
            
            SnowfallView(flakeCount: 30)
            
            VStack(spacing: 0) {
                Spacer().frame(height: 60)
                
                // Santa Info
                VStack(spacing: 6) {
                    Text("Santa Claus 🎅")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Đang kết nối cùng bé \(childName)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(ChristmasTheme.warmGold)
                    
                    Text(formatDuration(callDurationSeconds))
                        .font(.system(size: 16, weight: .semibold, design: .monospaced))
                        .foregroundColor(.white.opacity(0.85))
                        .padding(.top, 4)
                }
                
                Spacer()
                
                // Pulsing Avatar with Glow
                ZStack {
                    Circle()
                        .fill(ChristmasTheme.primaryRed.opacity(0.2))
                        .frame(width: 190, height: 190)
                        .scaleEffect(avatarPulsing)
                    
                    if let uiImage = UIImage(named: "santa_avatar") ?? UIImage(contentsOfFile: "d:/CallSantaClaus_iOS/CallSantaClaus/Resources/santa_avatar.jpg") {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(ChristmasTheme.goldenGlow, lineWidth: 3.5))
                            .shadow(color: ChristmasTheme.goldenGlow.opacity(0.4), radius: 16, x: 0, y: 8)
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 150, height: 150)
                            .foregroundColor(.white)
                    }
                }
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                        avatarPulsing = 1.1
                    }
                    SoundManager.shared.playSantaGreeting()
                }
                
                // Sound Waveform Visualizer
                VStack(spacing: 8) {
                    AudioWaveformView()
                    Text("Santa đang trò chuyện trực tiếp...")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.65))
                }
                .padding(.top, 20)
                
                Spacer()
                
                // Action Grid
                VStack(spacing: 20) {
                    HStack(spacing: 40) {
                        actionButton(icon: isMuted ? "mic.slash.fill" : "mic.fill", label: "Tắt tiếng", isActive: isMuted) {
                            isMuted.toggle()
                        }
                        
                        actionButton(icon: "video.fill", label: "Sang Video", isActive: false) {
                            SoundManager.shared.stopSantaGreeting()
                            onSwitchToVideo()
                        }
                        
                        actionButton(icon: isSpeakerOn ? "speaker.wave.3.fill" : "speaker.slash.fill", label: "Loa ngoài", isActive: isSpeakerOn) {
                            isSpeakerOn.toggle()
                        }
                    }
                    
                    // End Call
                    Button {
                        SoundManager.shared.stopSantaGreeting()
                        onEndCall()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(ChristmasTheme.primaryRed)
                                .frame(width: 72, height: 72)
                                .shadow(color: ChristmasTheme.primaryRed.opacity(0.6), radius: 10, x: 0, y: 5)
                            Image(systemName: "phone.down.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.top, 10)
                }
                .padding(.bottom, 60)
            }
        }
        .onReceive(callTimer) { _ in
            callDurationSeconds += 1
        }
        .onDisappear {
            SoundManager.shared.stopSantaGreeting()
        }
    }
    
    private func actionButton(icon: String, label: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        VStack(spacing: 8) {
            Button(action: action) {
                ZStack {
                    Circle()
                        .fill(isActive ? Color.white : Color.white.opacity(0.15))
                        .frame(width: 60, height: 60)
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundColor(isActive ? .black : .white)
                }
            }
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.85))
        }
    }
    
    private func formatDuration(_ totalSeconds: Int) -> String {
        let mins = totalSeconds / 60
        let secs = totalSeconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}
