import SwiftUI

public struct Snowflake: Identifiable {
    public let id: Int
    public var x: CGFloat
    public var y: CGFloat
    public var size: CGFloat
    public var speed: CGFloat
    public var swingOffset: CGFloat
    public var swingSpeed: CGFloat
    public var opacity: Double
}

public struct SnowfallView: View {
    @State private var snowflakes: [Snowflake] = []
    private let flakeCount: Int
    
    public init(flakeCount: Int = 45) {
        self.flakeCount = flakeCount
    }
    
    public var body: some View {
        GeometryReader { geometry in
            TimelineView(.animation) { timeline in
                Canvas { context, size in
                    let now = timeline.date.timeIntervalSinceReferenceDate
                    
                    for flake in snowflakes {
                        let swing = sin(now * flake.swingSpeed + flake.swingOffset) * 12.0
                        let currentX = flake.x + swing
                        let currentY = flake.y
                        
                        let rect = CGRect(
                            x: currentX.truncatingRemainder(dividingBy: size.width),
                            y: currentY.truncatingRemainder(dividingBy: size.height + 20),
                            width: flake.size,
                            height: flake.size
                        )
                        
                        context.opacity = flake.opacity
                        context.fill(Path(ellipseIn: rect), with: .color(.white))
                    }
                }
            }
            .onAppear {
                initializeSnowflakes(in: geometry.size)
            }
            .onChange(of: geometry.size) { newSize in
                initializeSnowflakes(in: newSize)
            }
        }
        .allowsHitTesting(false)
    }
    
    private func initializeSnowflakes(in size: CGSize) {
        guard size.width > 0 && size.height > 0 else { return }
        
        snowflakes = (0..<flakeCount).map { i in
            Snowflake(
                id: i,
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: 0...size.height),
                size: CGFloat.random(in: 2.5...6.5),
                speed: CGFloat.random(in: 25...65),
                swingOffset: Double.random(in: 0...Double.pi * 2),
                swingSpeed: Double.random(in: 1.0...2.5),
                opacity: Double.random(in: 0.35...0.85)
            )
        }
        
        // Timer for updating Y positions
        Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { _ in
            for index in snowflakes.indices {
                snowflakes[index].y += snowflakes[index].speed / 60.0
                if snowflakes[index].y > size.height + 20 {
                    snowflakes[index].y = -10
                    snowflakes[index].x = CGFloat.random(in: 0...size.width)
                }
            }
        }
    }
}
