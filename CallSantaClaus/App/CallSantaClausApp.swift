import SwiftUI

@main
struct CallSantaClausApp: App {
    @StateObject private var preferencesService = PreferencesService.shared
    @StateObject private var soundManager = SoundManager.shared
    @StateObject private var notificationService = NotificationService.shared
    
    var body: some Scene {
        WindowGroup {
            MainDashboardView()
                .environmentObject(preferencesService)
                .environmentObject(soundManager)
                .environmentObject(notificationService)
                .preferredColorScheme(.dark)
        }
    }
}
