import SwiftUI

public struct ChildProfileSheet: View {
    @ObservedObject var preferencesService = PreferencesService.shared
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var age: Int = 5
    @State private var behaviorStatus: String = ""
    @State private var wishlist: String = ""
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ZStack {
                ChristmasTheme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header Avatar
                        VStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(ChristmasTheme.primaryRed.opacity(0.2))
                                    .frame(width: 86, height: 86)
                                Image(systemName: "person.crop.circle.badge.checkmark")
                                    .font(.system(size: 46))
                                    .foregroundColor(ChristmasTheme.goldenGlow)
                            }
                            Text("Hồ Sơ Bé Ngoan")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Text("Santa sẽ trò chuyện và gọi đúng tên bé!")
                                .font(.system(size: 13))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding(.top, 10)
                        
                        // Inputs
                        VStack(spacing: 16) {
                            formField(title: "Tên thân mật của bé", icon: "face.smiling") {
                                TextField("Ví dụ: Bé Bo, Minh Anh...", text: $name)
                                    .textFieldStyle(.plain)
                                    .foregroundColor(.white)
                            }
                            
                            formField(title: "Tuổi của bé", icon: "birthday.cake") {
                                Stepper("\(age) tuổi", value: $age, in: 1...15)
                                    .foregroundColor(.white)
                            }
                            
                            formField(title: "Món quà bé ước đêm Noel", icon: "gift.fill") {
                                TextField("Ví dụ: Xe ô tô điều khiển, búp bê...", text: $wishlist)
                                    .textFieldStyle(.plain)
                                    .foregroundColor(.white)
                            }
                            
                            formField(title: "Trạng thái / Lời khen của Santa", icon: "star.fill") {
                                TextField("Ví dụ: Bé rất ngoan, chăm học và ăn nhiều rau...", text: $behaviorStatus)
                                    .textFieldStyle(.plain)
                                    .foregroundColor(.white)
                            }
                        }
                        
                        // Quick Presets
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Gợi ý trạng thái nhanh:")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.white.opacity(0.8))
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    presetChip("🌟 Bé rất chăm học bài")
                                    presetChip("🥦 Ăn hết suất rau củ")
                                    presetChip("🧸 Tự dọn đồ chơi gọn gàng")
                                    presetChip("⏰ Ngủ đúng giờ không khóc")
                                }
                            }
                        }
                        .padding(.top, 4)
                        
                        // Save Button
                        Button {
                            preferencesService.profile = ChildProfile(
                                name: name.isEmpty ? "Bé Yêu" : name,
                                behaviorStatus: behaviorStatus.isEmpty ? "Bé rất ngoan và chăm học" : behaviorStatus,
                                wishlist: wishlist.isEmpty ? "Một món đồ chơi bất ngờ" : wishlist,
                                age: age
                            )
                            dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Lưu Hồ Sơ Bé")
                                    .fontWeight(.bold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(ChristmasTheme.bannerGradient)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .shadow(color: ChristmasTheme.primaryRed.opacity(0.4), radius: 8, x: 0, y: 4)
                        }
                        .padding(.top, 10)
                    }
                    .padding(20)
                }
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
        .onAppear {
            let current = preferencesService.profile
            name = current.name
            age = current.age
            behaviorStatus = current.behaviorStatus
            wishlist = current.wishlist
        }
    }
    
    private func formField<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .foregroundColor(ChristmasTheme.goldenGlow)
                    .font(.system(size: 14))
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.85))
            }
            
            content()
                .padding(12)
                .background(Color.white.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.18), lineWidth: 1)
                )
        }
    }
    
    private func presetChip(_ text: String) -> some View {
        Button {
            behaviorStatus = text
        } label: {
            Text(text)
                .font(.system(size: 12))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.12))
                .foregroundColor(.white.opacity(0.9))
                .clipShape(Capsule())
        }
    }
}
