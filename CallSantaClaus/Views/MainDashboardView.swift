import SwiftUI

extension CallType: Identifiable {
    public var id: Self { self }
}

public struct MainDashboardView: View {
    @ObservedObject var preferencesService = PreferencesService.shared
    @ObservedObject var notificationService = NotificationService.shared
    
    // Sheets & Screens
    @State private var activeIncomingCallType: CallType?
    @State private var activeCallType: CallType?
    @State private var showChat: Bool = false
    @State private var showProfileSheet: Bool = false
    @State private var showScheduleSheet: Bool = false
    @State private var showVipSheet: Bool = false
    
    public init() {}
    
    public var body: some View {
        ZStack {
            ChristmasTheme.backgroundGradient
                .ignoresSafeArea()
            
            SnowfallView(flakeCount: 45)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Top App Bar
                    topBar
                    
                    // Countdown Banner
                    CountdownBannerView()
                    
                    // Santa Hero Card
                    santaHeroCard
                    
                    // Main Action Cards
                    actionCardsGrid
                    
                    // Child Profile Quick Banner
                    childProfilePreviewCard
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 18)
                .padding(.top, 10)
            }
        }
        // Incoming Call FullScreen Modal
        .fullScreenCover(item: Binding<CallType?>(
            get: { activeIncomingCallType },
            set: { activeIncomingCallType = $0 }
        )) { callType in
            IncomingCallView(
                callType: callType,
                childName: preferencesService.profile.name,
                onAccept: {
                    SoundManager.shared.stopRingtoneAndVibration()
                    activeIncomingCallType = nil
                    activeCallType = callType
                },
                onDecline: {
                    SoundManager.shared.stopRingtoneAndVibration()
                    activeIncomingCallType = nil
                }
            )
            .onAppear {
                SoundManager.shared.startRingtoneAndVibration()
            }
        }
        // Active Ongoing Call FullScreen Modal
        .fullScreenCover(item: Binding<CallType?>(
            get: { activeCallType },
            set: { activeCallType = $0 }
        )) { callType in
            if callType == .video {
                VideoCallView(
                    childName: preferencesService.profile.name,
                    onEndCall: {
                        activeCallType = nil
                    }
                )
            } else {
                VoiceCallView(
                    childName: preferencesService.profile.name,
                    onEndCall: {
                        activeCallType = nil
                    },
                    onSwitchToVideo: {
                        activeCallType = .video
                    }
                )
            }
        }
        // Chat FullScreen
        .fullScreenCover(isPresented: $showChat) {
            ChatView(
                childName: preferencesService.profile.name,
                wishlist: preferencesService.profile.wishlist,
                onBack: {
                    showChat = false
                },
                onStartVideoCall: {
                    showChat = false
                    activeIncomingCallType = .video
                }
            )
        }
        // Sheets
        .sheet(isPresented: $showProfileSheet) {
            ChildProfileSheet()
        }
        .sheet(isPresented: $showScheduleSheet) {
            ScheduleCallSheet()
        }
        .sheet(isPresented: $showVipSheet) {
            VipPassSheet()
        }
        .onAppear {
            notificationService.onCallTriggered = { callType in
                activeIncomingCallType = callType
            }
        }
    }
    
    // Top Bar
    private var topBar: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("SANTA CLAUS 🎄")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(ChristmasTheme.goldenGlow)
                Text("Gọi Điện Ông Già Noel")
                    .font(.system(size: 22, weight: .black, design: .rounded))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            // VIP Crown Button
            Button {
                showVipSheet = true
            } label: {
                HStack(spacing: 5) {
                    Image(systemName: "crown.fill")
                        .foregroundColor(ChristmasTheme.goldenGlow)
                    Text(preferencesService.isVip ? "VIP" : "PRO")
                        .font(.system(size: 12, weight: .black))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.black.opacity(0.4))
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(ChristmasTheme.goldenGlow, lineWidth: 1)
                )
            }
        }
        .padding(.vertical, 4)
    }
    
    // Santa Hero Card
    private var santaHeroCard: some View {
        HStack(spacing: 16) {
            // Avatar
            ZStack {
                Circle()
                    .fill(ChristmasTheme.primaryRed.opacity(0.3))
                    .frame(width: 84, height: 84)
                
                if let uiImage = UIImage(named: "santa_avatar") ?? UIImage(contentsOfFile: "d:/CallSantaClaus_iOS/CallSantaClaus/Resources/santa_avatar.jpg") {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 76, height: 76)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(ChristmasTheme.goldenGlow, lineWidth: 2))
                } else {
                    Circle().fill(Color.gray).frame(width: 76, height: 76)
                }
            }
            
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 6) {
                    Text("Santa Claus")
                        .font(.system(size: 19, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(ChristmasTheme.goldenGlow)
                        .font(.system(size: 14))
                }
                
                Text("Đang ở xưởng quà Bắc Cực cùng tuần lộc Rudolph")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.75))
                    .lineLimit(2)
                
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 7, height: 7)
                    Text("Đang rảnh tay • Sẵn sàng gọi ngay")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(Color(red: 0.4, green: 1.0, blue: 0.6))
                }
                .padding(.top, 2)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            ZStack {
                ChristmasTheme.cardGradient
                RoundedRectangle(cornerRadius: 20)
                    .stroke(ChristmasTheme.borderGlow, lineWidth: 1)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    // Action Cards Grid
    private var actionCardsGrid: some View {
        VStack(spacing: 14) {
            // Big Primary Buttons
            HStack(spacing: 14) {
                // Video Call Button
                Button {
                    activeIncomingCallType = .video
                } label: {
                    VStack(alignment: .leading, spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(ChristmasTheme.greenCallGradient)
                                .frame(width: 50, height: 50)
                            Image(systemName: "video.fill")
                                .font(.system(size: 22))
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Gọi Video")
                                .font(.system(size: 17, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Text("FaceTime Santa")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.75))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(ChristmasTheme.cardGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(ChristmasTheme.borderGlow, lineWidth: 1)
                    )
                }
                
                // Voice Call Button
                Button {
                    activeIncomingCallType = .voice
                } label: {
                    VStack(alignment: .leading, spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(ChristmasTheme.bannerGradient)
                                .frame(width: 50, height: 50)
                            Image(systemName: "phone.fill")
                                .font(.system(size: 22))
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Gọi Thoại")
                                .font(.system(size: 17, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Text("Nghe giọng Santa")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.75))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(ChristmasTheme.cardGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(ChristmasTheme.borderGlow, lineWidth: 1)
                    )
                }
            }
            
            // Secondary Actions
            HStack(spacing: 14) {
                // Live Chat Button
                Button {
                    showChat = true
                } label: {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.3))
                                .frame(width: 44, height: 44)
                            Image(systemName: "message.fill")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Nhắn Tin")
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Text("Chat với Santa")
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(14)
                    .background(ChristmasTheme.cardGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(ChristmasTheme.borderGlow, lineWidth: 1)
                    )
                }
                
                // Schedule Call Button
                Button {
                    showScheduleSheet = true
                } label: {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(ChristmasTheme.goldenGlow.opacity(0.3))
                                .frame(width: 44, height: 44)
                            Image(systemName: "alarm.fill")
                                .font(.system(size: 18))
                                .foregroundColor(ChristmasTheme.goldenGlow)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Hẹn Giờ")
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Text("Đổ chuông gọi bé")
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(14)
                    .background(ChristmasTheme.cardGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(ChristmasTheme.borderGlow, lineWidth: 1)
                    )
                }
            }
        }
    }
    
    // Child Profile Preview Card
    private var childProfilePreviewCard: some View {
        Button {
            showProfileSheet = true
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(ChristmasTheme.goldenGlow.opacity(0.2))
                        .frame(width: 46, height: 46)
                    Image(systemName: "person.crop.circle.badge.checkmark")
                        .font(.system(size: 22))
                        .foregroundColor(ChristmasTheme.goldenGlow)
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text("Bé: \(preferencesService.profile.name) (\(preferencesService.profile.age) tuổi)")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                        Text("✏️")
                            .font(.system(size: 11))
                    }
                    
                    Text("Ước: \(preferencesService.profile.wishlist)")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.75))
                        .lineLimit(1)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(14)
            .background(Color.white.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(ChristmasTheme.goldenGlow.opacity(0.3), lineWidth: 1)
            )
        }
    }
}
