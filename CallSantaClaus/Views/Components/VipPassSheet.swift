import SwiftUI

public struct VipPassSheet: View {
    @ObservedObject var preferencesService = PreferencesService.shared
    @Environment(\.dismiss) private var dismiss
    @State private var isPurchasing = false
    @State private var showSuccess = false
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ZStack {
                ChristmasTheme.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Badge Header
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(ChristmasTheme.goldenGlow.opacity(0.25))
                                .frame(width: 90, height: 90)
                            Image(systemName: "crown.fill")
                                .font(.system(size: 44))
                                .foregroundColor(ChristmasTheme.goldenGlow)
                        }
                        
                        Text("Santa Claus VIP Magic")
                            .font(.system(size: 24, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Trải nghiệm Giáng Sinh ma thuật không giới hạn dành riêng cho gia đình bạn")
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                    }
                    .padding(.top, 16)
                    
                    // Perks
                    VStack(alignment: .leading, spacing: 14) {
                        perkRow(icon: "video.badge.waveform.fill", title: "Video Call Không Giới Hạn", desc: "Gọi FaceTime trực tiếp xưởng quà Bắc Cực bất cứ lúc nào")
                        perkRow(icon: "sparkles", title: "Santa Trả Lời Siêu Tốc", desc: "Chat thông minh không giới hạn thời gian")
                        perkRow(icon: "gift.fill", title: "Chứng Nhận Bé Ngoan VIP", desc: "Giấy khen chính thức có chữ ký của Santa")
                        perkRow(icon: "bell.and.waveform.fill", title: "Âm Thanh & Nhạc Chuông Độc Quyền", desc: "Gói nhạc chuông Jingle Bells phòng thu cao cấp")
                    }
                    .padding(18)
                    .background(Color.white.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(ChristmasTheme.goldenGlow.opacity(0.3), lineWidth: 1)
                    )
                    
                    Spacer()
                    
                    // Purchase Button
                    VStack(spacing: 10) {
                        Button {
                            isPurchasing = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                isPurchasing = false
                                preferencesService.isVip = true
                                showSuccess = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    dismiss()
                                }
                            }
                        } label: {
                            HStack {
                                if isPurchasing {
                                    ProgressView()
                                        .tint(.black)
                                } else if showSuccess {
                                    Image(systemName: "checkmark")
                                    Text("Đã Kích Hoạt VIP!")
                                } else {
                                    Image(systemName: "crown.fill")
                                    Text("Mở Khóa VIP - Miễn Phí Trải Nghiệm")
                                }
                            }
                            .font(.system(size: 16, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(ChristmasTheme.goldButtonGradient)
                            .foregroundColor(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .shadow(color: ChristmasTheme.goldenGlow.opacity(0.5), radius: 10, x: 0, y: 5)
                        }
                        
                        Text("Mô phỏng giao dịch App Store an toàn cho bé")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.5))
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
    
    private func perkRow(icon: String, title: String, desc: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(ChristmasTheme.goldenGlow)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                Text(desc)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.7))
            }
        }
    }
}
