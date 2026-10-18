import SwiftUI

public struct ScheduleCallSheet: View {
    @ObservedObject var notificationService = NotificationService.shared
    @ObservedObject var preferencesService = PreferencesService.shared
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedDelay: Int = 10
    @State private var selectedCallType: CallType = .video
    
    private let delays = [
        (10, "10 Giây", "Thử nghiệm ngay"),
        (30, "30 Giây", "Vừa đủ chuẩn bị"),
        (60, "1 Phút", "Tạo bất ngờ cho bé"),
        (300, "5 Phút", "Đưa máy cho bé"),
        (900, "15 Phút", "Trước giờ đi ngủ")
    ]
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ZStack {
                ChristmasTheme.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 22) {
                    // Header
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(ChristmasTheme.goldenGlow.opacity(0.2))
                                .frame(width: 80, height: 80)
                            Image(systemName: "alarm.waves.left.and.right.fill")
                                .font(.system(size: 40))
                                .foregroundColor(ChristmasTheme.goldenGlow)
                        }
                        Text("Hẹn Giờ Đổ Chuông")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Text("Santa sẽ tự động gọi đến điện thoại đúng giờ hẹn!")
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.75))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 10)
                    
                    // Call Type Selector
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Hình thức cuộc gọi:")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white.opacity(0.85))
                        
                        HStack(spacing: 12) {
                            callTypeButton(type: .video, icon: "video.fill", title: "Video Call")
                            callTypeButton(type: .voice, icon: "phone.fill", title: "Voice Call")
                        }
                    }
                    
                    // Delay Selector
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Thời gian đổ chuông:")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white.opacity(0.85))
                        
                        VStack(spacing: 8) {
                            ForEach(delays, id: \.0) { delay, title, subtitle in
                                Button {
                                    selectedDelay = delay
                                } label: {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(title)
                                                .font(.system(size: 15, weight: .bold))
                                                .foregroundColor(.white)
                                            Text(subtitle)
                                                .font(.system(size: 12))
                                                .foregroundColor(.white.opacity(0.65))
                                        }
                                        Spacer()
                                        if selectedDelay == delay {
                                            Image(systemName: "checkmark.circle.fill")
                                                .font(.system(size: 20))
                                                .foregroundColor(ChristmasTheme.goldenGlow)
                                        }
                                    }
                                    .padding(12)
                                    .background(selectedDelay == delay ? Color.white.opacity(0.18) : Color.white.opacity(0.08))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(selectedDelay == delay ? ChristmasTheme.goldenGlow : Color.white.opacity(0.15), lineWidth: selectedDelay == delay ? 1.5 : 1)
                                    )
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Start Schedule Button
                    Button {
                        notificationService.scheduleCall(
                            delaySeconds: selectedDelay,
                            callType: selectedCallType,
                            childName: preferencesService.profile.name
                        )
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "bell.badge.fill")
                            Text("Bắt Đầu Hẹn Giờ (\(selectedDelay)s)")
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(ChristmasTheme.bannerGradient)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .shadow(color: ChristmasTheme.primaryRed.opacity(0.4), radius: 8, x: 0, y: 4)
                    }
                }
                .padding(20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Đóng") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
    
    private func callTypeButton(type: CallType, icon: String, title: String) -> some View {
        Button {
            selectedCallType = type
        } label: {
            HStack(spacing: 8) {
                Image(systemName: icon)
                Text(title)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(selectedCallType == type ? ChristmasTheme.primaryRed : Color.white.opacity(0.1))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(selectedCallType == type ? ChristmasTheme.goldenGlow : Color.clear, lineWidth: 1.5)
            )
        }
    }
}
