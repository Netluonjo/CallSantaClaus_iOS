import Foundation

public enum CallType: String, Codable, CaseIterable {
    case video = "VIDEO"
    case voice = "VOICE"
    
    public var title: String {
        switch self {
        case .video: return "Cuộc Gọi Video"
        case .voice: return "Cuộc Gọi Thoại"
        }
    }
}

public struct ChildProfile: Codable, Equatable {
    public var name: String
    public var behaviorStatus: String
    public var wishlist: String
    public var age: Int
    
    public init(
        name: String = "Bé Yêu",
        behaviorStatus: String = "Bé rất ngoan và chăm học",
        wishlist: String = "Một món đồ chơi bất ngờ",
        age: Int = 5
    ) {
        self.name = name
        self.behaviorStatus = behaviorStatus
        self.wishlist = wishlist
        self.age = age
    }
}

public struct ChatMessage: Identifiable, Codable, Equatable {
    public var id: String
    public var sender: String
    public var text: String
    public var isFromSanta: Bool
    public var timestamp: Date
    
    public init(
        id: String = UUID().uuidString,
        sender: String,
        text: String,
        isFromSanta: Bool,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.sender = sender
        self.text = text
        self.isFromSanta = isFromSanta
        self.timestamp = timestamp
    }
}
