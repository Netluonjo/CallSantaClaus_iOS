import SwiftUI

public struct ChristmasTheme {
    // Brand Festive Colors
    public static let primaryRed = Color(red: 0.83, green: 0.14, blue: 0.15)       // #D42426
    public static let deepBerry = Color(red: 0.62, green: 0.06, blue: 0.07)        // #9E1012
    public static let pineGreen = Color(red: 0.09, green: 0.36, blue: 0.20)        // #165B33
    public static let brightGreen = Color(red: 0.13, green: 0.69, blue: 0.30)      // #22B04D
    public static let goldenGlow = Color(red: 0.97, green: 0.70, blue: 0.16)       // #F8B229
    public static let warmGold = Color(red: 1.0, green: 0.84, blue: 0.35)          // #FFD700
    
    // Background Dark Sky Tones
    public static let midnightSky = Color(red: 0.05, green: 0.09, blue: 0.15)      // #0D1726
    public static let deepNavy = Color(red: 0.08, green: 0.14, blue: 0.24)         // #14243D
    public static let frostedGlass = Color.white.opacity(0.12)
    public static let borderGlow = Color.white.opacity(0.25)
    
    // Gradients
    public static let backgroundGradient = LinearGradient(
        colors: [midnightSky, deepNavy, Color(red: 0.05, green: 0.18, blue: 0.15)],
        startPoint: .top,
        endPoint: .bottom
    )
    
    public static let bannerGradient = LinearGradient(
        colors: [primaryRed, deepBerry, Color(red: 0.45, green: 0.04, blue: 0.05)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    public static let goldButtonGradient = LinearGradient(
        colors: [goldenGlow, warmGold],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    public static let greenCallGradient = LinearGradient(
        colors: [brightGreen, pineGreen],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    public static let redDeclineGradient = LinearGradient(
        colors: [Color(red: 0.95, green: 0.2, blue: 0.2), deepBerry],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    public static let cardGradient = LinearGradient(
        colors: [Color.white.opacity(0.14), Color.white.opacity(0.05)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
