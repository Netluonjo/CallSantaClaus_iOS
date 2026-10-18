import Foundation
import UserNotifications

public final class NotificationService: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    public static let shared = NotificationService()
    
    @Published public var scheduledCallType: CallType?
    @Published public var scheduledTriggerDate: Date?
    
    private var internalTimer: Timer?
    public var onCallTriggered: ((CallType) -> Void)?
    
    override private init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    public func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }
    
    public func scheduleCall(delaySeconds: Int, callType: CallType, childName: String) {
        requestAuthorization()
        
        let content = UNMutableNotificationContent()
        content.title = "🎅 Ông Già Noel Đang Gọi Đến!"
        content.body = "Santa Claus từ Bắc Cực đang gọi cho \(childName). Nhấc máy ngay nào!"
        content.sound = UNNotificationSound.default
        content.userInfo = ["CALL_TYPE": callType.rawValue]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(delaySeconds), repeats: false)
        let request = UNNotificationRequest(identifier: "santa_incoming_call", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        
        // Also run an internal foreground timer to show incoming call screen automatically
        internalTimer?.invalidate()
        scheduledCallType = callType
        scheduledTriggerDate = Date().addingTimeInterval(TimeInterval(delaySeconds))
        
        internalTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(delaySeconds), repeats: false) { [weak self] _ in
            DispatchQueue.main.async {
                self?.scheduledCallType = nil
                self?.scheduledTriggerDate = nil
                self?.onCallTriggered?(callType)
            }
        }
    }
    
    public func cancelSchedule() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["santa_incoming_call"])
        internalTimer?.invalidate()
        internalTimer = nil
        scheduledCallType = nil
        scheduledTriggerDate = nil
    }
    
    // UNUserNotificationCenterDelegate
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }
    
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        if let typeStr = userInfo["CALL_TYPE"] as? String,
           let callType = CallType(rawValue: typeStr) {
            DispatchQueue.main.async {
                self.onCallTriggered?(callType)
            }
        }
        completionHandler()
    }
}
