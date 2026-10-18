import SwiftUI

public struct AudioWaveformView: View {
    @ObservedObject var soundManager = SoundManager.shared
    @State private var phase: Double = 0
    private let barCount: Int = 24
    
    public init() {}
    
    public var body: some View {
        TimelineView(.animation) { timeline in
            HStack(spacing: 5) {
                ForEach(0..<barCount, id: \.self) { index in
                    let normalizedPower = soundManager.isPlayingGreeting ? Double(soundManager.audioPower) : 0.15
                    let offset = Double(index) * 0.35
                    let wave = sin(timeline.date.timeIntervalSinceReferenceDate * 6.0 + offset)
                    let heightFactor = max(0.12, abs(wave) * normalizedPower)
                    
                    RoundedRectangle(cornerRadius: 3)
                        .fill(
                            LinearGradient(
                                colors: [ChristmasTheme.goldenGlow, ChristmasTheme.primaryRed],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 4, height: CGFloat(heightFactor * 65.0))
                        .animation(.easeInOut(duration: 0.08), value: heightFactor)
                }
            }
            .frame(height: 70)
        }
    }
}
