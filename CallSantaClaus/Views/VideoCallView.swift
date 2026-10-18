import SwiftUI
import AVFoundation

public struct VideoCallView: View {
    public let childName: String
    public let onEndCall: () -> Void
    
    @StateObject private var cameraManager = CameraManager()
    @State private var callDurationSeconds: Int = 0
    @State private var isMuted: Bool = false
    @State private var isSpeakerOn: Bool = true
    @State private var santaZoom: CGFloat = 1.0
    @State private var pipPosition: CGSize = .zero
    
    private let callTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    public init(childName: String, onEndCall: @escaping () -> Void) {
        self.childName = childName
        self.onEndCall = onEndCall
    }
    
    public var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            // Santa Live Video Feed Simulation
            GeometryReader { proxy in
                if let uiImage = UIImage(named: "santa_video_call") ?? UIImage(contentsOfFile: "d:/CallSantaClaus_iOS/CallSantaClaus/Resources/santa_video_call.jpg") {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .scaleEffect(santaZoom)
                        .clipped()
                } else {
                    ChristmasTheme.backgroundGradient
                }
            }
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
                    santaZoom = 1.04
                }
                SoundManager.shared.playSantaGreeting()
            }
            
            // Snowfall Overlay
            SnowfallView(flakeCount: 30)
            
            // Top Call Info Bar
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 6) {
                            Text("Santa Claus")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Text("🎅")
                        }
                        
                        HStack(spacing: 6) {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 8, height: 8)
                            Text(formatDuration(callDurationSeconds))
                                .font(.system(size: 13, weight: .semibold, design: .monospaced))
                                .foregroundColor(.white.opacity(0.9))
                            Text("• Bắc Cực Trực Tiếp")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.75))
                        }
                    }
                    
                    Spacer()
                    
                    // Child Name Badge
                    Text("Bé: \(childName)")
                        .font(.system(size: 12, weight: .bold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.black.opacity(0.4))
                        .foregroundColor(ChristmasTheme.warmGold)
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 20)
                .padding(.top, 50)
                
                Spacer()
            }
            
            // Picture-in-Picture (PiP) Child Selfie Camera
            VStack {
                HStack {
                    Spacer()
                    ZStack {
                        if cameraManager.isCameraAuthorized {
                            CameraPreviewView(session: cameraManager.session)
                                .frame(width: 110, height: 160)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.white, lineWidth: 2)
                                )
                                .shadow(color: Color.black.opacity(0.4), radius: 8, x: 0, y: 4)
                        } else {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.black.opacity(0.7))
                                .frame(width: 110, height: 160)
                                .overlay(
                                    VStack(spacing: 4) {
                                        Image(systemName: "camera.fill")
                                            .foregroundColor(.white.opacity(0.8))
                                        Text("Camera Bé")
                                            .font(.system(size: 11))
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
                                )
                        }
                    }
                    .padding(.trailing, 16)
                    .padding(.top, 100)
                    .offset(pipPosition)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                pipPosition = value.translation
                            }
                            .onEnded { _ in
                                withAnimation(.spring()) {
                                    pipPosition = .zero
                                }
                            }
                    )
                }
                Spacer()
            }
            
            // Bottom Controls Bar
            VStack {
                Spacer()
                
                HStack(spacing: 24) {
                    // Flip Camera
                    controlButton(icon: "camera.rotate.fill", isActive: false) {
                        cameraManager.flipCamera()
                    }
                    
                    // Mute Audio
                    controlButton(icon: isMuted ? "mic.slash.fill" : "mic.fill", isActive: isMuted) {
                        isMuted.toggle()
                    }
                    
                    // Speaker
                    controlButton(icon: isSpeakerOn ? "speaker.wave.3.fill" : "speaker.slash.fill", isActive: isSpeakerOn) {
                        isSpeakerOn.toggle()
                    }
                    
                    // End Call
                    Button {
                        SoundManager.shared.stopSantaGreeting()
                        cameraManager.stopSession()
                        onEndCall()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(ChristmasTheme.primaryRed)
                                .frame(width: 66, height: 66)
                                .shadow(color: ChristmasTheme.primaryRed.opacity(0.7), radius: 10, x: 0, y: 5)
                            Image(systemName: "phone.down.fill")
                                .font(.system(size: 26))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 32)
                        .fill(Color.black.opacity(0.55))
                        .overlay(
                            RoundedRectangle(cornerRadius: 32)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .onReceive(callTimer) { _ in
            callDurationSeconds += 1
        }
        .onDisappear {
            SoundManager.shared.stopSantaGreeting()
            cameraManager.stopSession()
        }
    }
    
    private func controlButton(icon: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(isActive ? Color.white : Color.white.opacity(0.2))
                    .frame(width: 50, height: 50)
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(isActive ? .black : .white)
            }
        }
    }
    
    private func formatDuration(_ totalSeconds: Int) -> String {
        let mins = totalSeconds / 60
        let secs = totalSeconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}
