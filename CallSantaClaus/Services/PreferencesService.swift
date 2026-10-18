import Foundation
import Combine

public final class PreferencesService: ObservableObject {
    public static let shared = PreferencesService()
    
    private let defaults = UserDefaults.standard
    private let profileKey = "santa_child_profile"
    private let chatHistoryKey = "santa_chat_history"
    private let isVipKey = "santa_is_vip"
    
    @Published public var profile: ChildProfile {
        didSet {
            saveProfile()
        }
    }
    
    @Published public var isVip: Bool {
        didSet {
            defaults.set(isVip, forKey: isVipKey)
        }
    }
    
    public init() {
        self.isVip = defaults.bool(forKey: isVipKey)
        
        if let data = defaults.data(forKey: profileKey),
           let decoded = try? JSONDecoder().decode(ChildProfile.self, from: data) {
            self.profile = decoded
        } else {
            self.profile = ChildProfile()
        }
    }
    
    private func saveProfile() {
        if let data = try? JSONEncoder().encode(profile) {
            defaults.set(data, forKey: profileKey)
        }
    }
    
    public func getChatMessages() -> [ChatMessage] {
        guard let data = defaults.data(forKey: chatHistoryKey),
              let messages = try? JSONDecoder().decode([ChatMessage].self, from: data) else {
            return []
        }
        return messages
    }
    
    public func saveChatMessages(_ messages: [ChatMessage]) {
        if let data = try? JSONEncoder().encode(messages) {
            defaults.set(data, forKey: chatHistoryKey)
        }
    }
    
    public func clearChatHistory() {
        defaults.removeObject(forKey: chatHistoryKey)
    }
}
