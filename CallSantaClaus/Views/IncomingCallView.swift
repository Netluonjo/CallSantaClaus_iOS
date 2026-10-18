import SwiftUI

public struct IncomingCallView: View {
    public let callType: CallType
    public let childName: String
    public let onAccept: () -> Void
    public let onDecline: () -> Void
    
    @State private var rippleScale: CGFloat = 1.0
    @State private var rippleOpacity: Double = 0.8
    @State private var buttonPulse: CGFloat = 1.0
    
    public init(
        callType: CallType,
        childName: String,
        onAccept: @escaping () -> Void,
        onDecline: @escaping () -> Void
    ) {
        self.callType = callType
        self.childName = childName
        self.onAccept = onAccept
        self.onDecline = onDecline
    }
    
    public var body: some View {
        ZStack {
            ChristmasTheme.backgroundGradient
                .ignoresSafeArea()
            
            SnowfallView(flakeCount: 40)
            
            VStack(spacing: 0) {
                Spacer().frame(height: 60)
                
                // Santa Call Status
                VStack(spacing: 8) {
                    HStack(spacing: 6) {
                        Image(systemName: callType == .video ? "video.fill" : "phone.fill")
                            .foregroundColor(ChristmasTheme.goldenGlow)
                        Text(callType == .video ? "CUỘC GỌI FACETIME ĐẾN" : "CUỘC GỌI THOẠI ĐẾN")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundColor(ChristmasTheme.goldenGlow)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(Color.black.opacity(0.4))
                    .clipShape(Capsule())
                    
                    Text("Santa Claus 🎅")
                        .font(.system(size: 34, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Bắc Cực • Xưởng Quà Tuyết Trắng")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("Đang gọi cho: \(childName)")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(ChristmasTheme.warmGold)
                        .padding(.top, 4)
                }
                
                Spacer()
                
                // Pulsating Santa Avatar
                ZStack {
                    // Outer Ripple 1
                    Circle()
                        .stroke(ChristmasTheme.primaryRed.opacity(0.4), lineWidth: 3)
                        .frame(width: 220 * rippleScale, height: 220 * rippleScale)
                        .opacity(rippleOpacity)
                    
                    // Outer Ripple 2
                    Circle()
                        .stroke(ChristmasTheme.goldenGlow.opacity(0.5), lineWidth: 2)
                        .frame(width: 180 * rippleScale, height: 180 * rippleScale)
                        .opacity(rippleOpacity)
                    
                    // Avatar Image
                    if let uiImage = UIImage(named: "santa_avatar") ?? UIImage(contentsOfFile: "d:/CallSantaClaus_iOS/CallSantaClaus/Resources/santa_avatar.jpg") {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(ChristmasTheme.goldenGlow, lineWidth: 4))
                            .shadow(color: ChristmasTheme.primaryRed.opacity(0.6), radius: 20, x: 0, y: 10)
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .foregroundColor(.white)
                    }
                }
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                        rippleScale = 1.15
                        rippleOpacity = 0.2
                    }
                    withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                        buttonPulse = 1.08
                    }
                }
                
                Spacer()
                
                // Action Buttons
                HStack(spacing: 60) {
                    // Decline Button
                    VStack(spacing: 8) {
                        Button {
                            onDecline()
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(ChristmasTheme.redDeclineGradient)
                                    .frame(width: 76, height: 76)
                                    .shadow(color: ChristmasTheme.primaryRed.opacity(0.6), radius: 10, x: 0, y: 5)
                                Image(systemName: "phone.down.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                            }
                        }
                        Text("Từ chối")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.85))
                    }
                    
                    // Accept Button
                    VStack(spacing: 8) {
                        Button {
                            onAccept()
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(ChristmasTheme.greenCallGradient)
                                    .frame(width: 76, height: 76)
                                    .scaleEffect(buttonPulse)
                                    .shadow(color: ChristmasTheme.brightGreen.opacity(0.7), radius: 14, x: 0, y: 6)
                                Image(systemName: callType == .video ? "video.fill" : "phone.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                            }
                        }
                        Text("Nghe máy")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .padding(.bottom, 60)
            }
        }
    }
}
