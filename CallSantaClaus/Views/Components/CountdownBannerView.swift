import SwiftUI

public struct CountdownBannerView: View {
    @State private var timeRemaining: String = "..."
    @State private var daysRemaining: Int = 0
    @State private var hoursRemaining: Int = 0
    @State private var minutesRemaining: Int = 0
    @State private var secondsRemaining: Int = 0
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 12) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .foregroundColor(ChristmasTheme.goldenGlow)
                    Text("ĐẾM NGƯỢC ĐÊM NOEL")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(ChristmasTheme.goldenGlow)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.black.opacity(0.35))
                .clipShape(Capsule())
                
                Spacer()
                
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 8, height: 8)
                    Text("Bắc Cực 🟢")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.85))
                }
            }
            
            HStack(spacing: 10) {
                timeSegment(value: daysRemaining, label: "Ngày")
                separator
                timeSegment(value: hoursRemaining, label: "Giờ")
                separator
                timeSegment(value: minutesRemaining, label: "Phút")
                separator
                timeSegment(value: secondsRemaining, label: "Giây")
            }
            .padding(.vertical, 6)
        }
        .padding(16)
        .background(
            ZStack {
                ChristmasTheme.bannerGradient
                RoundedRectangle(cornerRadius: 20)
                    .stroke(ChristmasTheme.borderGlow, lineWidth: 1)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: ChristmasTheme.deepBerry.opacity(0.4), radius: 12, x: 0, y: 6)
        .onReceive(timer) { _ in
            updateCountdown()
        }
        .onAppear {
            updateCountdown()
        }
    }
    
    private var separator: some View {
        Text(":")
            .font(.system(size: 20, weight: .black, design: .rounded))
            .foregroundColor(.white.opacity(0.6))
            .offset(y: -8)
    }
    
    private func timeSegment(value: Int, label: String) -> some View {
        VStack(spacing: 2) {
            Text(String(format: "%02d", max(0, value)))
                .font(.system(size: 26, weight: .black, design: .rounded))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.75))
        }
        .frame(minWidth: 50)
        .padding(.vertical, 6)
        .background(Color.white.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    private func updateCountdown() {
        let now = Date()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        
        var targetComponents = calendar.dateComponents([.year], from: now)
        targetComponents.month = 12
        targetComponents.day = 24
        targetComponents.hour = 20
        targetComponents.minute = 0
        targetComponents.second = 0
        
        guard var targetDate = calendar.date(from: targetComponents) else { return }
        if targetDate < now {
            targetComponents.year! += 1
            targetDate = calendar.date(from: targetComponents)!
        }
        
        let diff = calendar.dateComponents([.day, .hour, .minute, .second], from: now, to: targetDate)
        daysRemaining = diff.day ?? 0
        hoursRemaining = diff.hour ?? 0
        minutesRemaining = diff.minute ?? 0
        secondsRemaining = diff.second ?? 0
    }
}
