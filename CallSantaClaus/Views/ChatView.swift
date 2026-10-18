import SwiftUI

public struct ChatView: View {
    public let childName: String
    public let wishlist: String
    public let onBack: () -> Void
    public let onStartVideoCall: () -> Void
    
    @ObservedObject var preferencesService = PreferencesService.shared
    @State private var messages: [ChatMessage] = []
    @State private var inputText: String = ""
    @State private var isSantaTyping: Bool = false
    
    private let quickPrompts = [
        "Xin quà Noel 🎁",
        "Tuần lộc Rudolph đâu rồi? 🦌",
        "Cháu có ngoan không ạ? ⭐",
        "Thời tiết Bắc Cực thế nào? ❄️",
        "Bà già Noel đang làm gì? 🍪",
        "Kể chuyện cho cháu nghe 📖",
        "Santa bao nhiêu tuổi rồi? 🎂",
        "Làm sao Santa vào nhà được? 🔑"
    ]
    
    public init(
        childName: String,
        wishlist: String,
        onBack: @escaping () -> Void,
        onStartVideoCall: @escaping () -> Void
    ) {
        self.childName = childName
        self.wishlist = wishlist
        self.onBack = onBack
        self.onStartVideoCall = onStartVideoCall
    }
    
    public var body: some View {
        ZStack {
            ChristmasTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Custom Navigation Bar
                HStack(spacing: 12) {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(8)
                    }
                    
                    // Santa Avatar & Status
                    ZStack(alignment: .bottomTrailing) {
                        if let uiImage = UIImage(named: "santa_avatar") ?? UIImage(contentsOfFile: "d:/CallSantaClaus_iOS/CallSantaClaus/Resources/santa_avatar.jpg") {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 44, height: 44)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(ChristmasTheme.goldenGlow, lineWidth: 1.5))
                        } else {
                            Circle().fill(Color.gray).frame(width: 44, height: 44)
                        }
                        
                        Circle()
                            .fill(Color.green)
                            .frame(width: 12, height: 12)
                            .overlay(Circle().stroke(Color.black, lineWidth: 1.5))
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Santa Claus 🎅")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                        Text("Trực tuyến tại Bắc Cực")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.75))
                    }
                    
                    Spacer()
                    
                    // Call Video Shortcut
                    Button(action: onStartVideoCall) {
                        ZStack {
                            Circle()
                                .fill(ChristmasTheme.primaryRed)
                                .frame(width: 38, height: 38)
                            Image(systemName: "video.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                        }
                    }
                    
                    // Clear Chat Menu
                    Button {
                        preferencesService.clearChatHistory()
                        messages.removeAll()
                        sendInitialSantaGreeting()
                    } label: {
                        Image(systemName: "trash")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.7))
                            .padding(6)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.black.opacity(0.35))
                
                // Messages List
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(messages) { msg in
                                messageRow(msg)
                                    .id(msg.id)
                            }
                            
                            if isSantaTyping {
                                HStack(spacing: 8) {
                                    ProgressView()
                                        .tint(ChristmasTheme.goldenGlow)
                                        .scaleEffect(0.8)
                                    Text("Santa đang soạn tin nhắn...")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(ChristmasTheme.goldenGlow)
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 6)
                                .id("typing_indicator")
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                    }
                    .onChange(of: messages.count) { _ in
                        if let last = messages.last {
                            withAnimation {
                                proxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                    .onChange(of: isSantaTyping) { typing in
                        if typing {
                            withAnimation {
                                proxy.scrollTo("typing_indicator", anchor: .bottom)
                            }
                        }
                    }
                }
                
                // Quick Suggestion Chips
                VStack(spacing: 8) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(quickPrompts, id: \.self) { prompt in
                                Button {
                                    sendMessage(prompt)
                                } label: {
                                    Text(prompt)
                                        .font(.system(size: 12, weight: .medium))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.white.opacity(0.12))
                                        .foregroundColor(.white)
                                        .clipShape(Capsule())
                                        .overlay(Capsule().stroke(Color.white.opacity(0.2), lineWidth: 1))
                                }
                            }
                        }
                        .padding(.horizontal, 14)
                    }
                    
                    // Input Bar
                    HStack(spacing: 10) {
                        TextField("Nhắn cho Santa điều bé muốn...", text: $inputText)
                            .textFieldStyle(.plain)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(Color.white.opacity(0.12))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                        
                        Button {
                            sendMessage(inputText)
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(ChristmasTheme.primaryRed)
                                    .frame(width: 42, height: 42)
                                Image(systemName: "arrow.up")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        .disabled(inputText.trimmingCharacters(in: .whitespaces).isEmpty)
                        .opacity(inputText.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1.0)
                    }
                    .padding(.horizontal, 14)
                    .padding(.bottom, 12)
                }
                .padding(.top, 6)
                .background(Color.black.opacity(0.35))
            }
        }
        .onAppear {
            let saved = preferencesService.getChatMessages()
            if saved.isEmpty {
                sendInitialSantaGreeting()
            } else {
                messages = saved
            }
        }
    }
    
    private func messageRow(_ msg: ChatMessage) -> some View {
        HStack(alignment: .bottom, spacing: 8) {
            if msg.isFromSanta {
                if let uiImage = UIImage(named: "santa_avatar") ?? UIImage(contentsOfFile: "d:/CallSantaClaus_iOS/CallSantaClaus/Resources/santa_avatar.jpg") {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 28, height: 28)
                        .clipShape(Circle())
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(msg.text)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .padding(12)
                        .background(
                            LinearGradient(
                                colors: [ChristmasTheme.primaryRed, ChristmasTheme.deepBerry],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .frame(maxWidth: 270, alignment: .leading)
                
                Spacer()
            } else {
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(msg.text)
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .padding(12)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .frame(maxWidth: 270, alignment: .trailing)
            }
        }
    }
    
    private func sendInitialSantaGreeting() {
        let greeting = ChatMessage(
            sender: "Santa Claus",
            text: "Ho Ho Ho! 🎅 Chào bé \(childName) yêu quý! Santa đang ở xưởng quà Bắc Cực đây. Cháu có điều gì muốn nhắn nhủ hay xin quà Santa không nào?",
            isFromSanta: true
        )
        messages = [greeting]
        preferencesService.saveChatMessages(messages)
    }
    
    private func sendMessage(_ text: String) {
        let clean = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !clean.isEmpty else { return }
        
        let userMsg = ChatMessage(
            sender: childName,
            text: clean,
            isFromSanta: false
        )
        messages.append(userMsg)
        inputText = ""
        preferencesService.saveChatMessages(messages)
        
        // Santa reply simulation
        isSantaTyping = true
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 1.0...1.8)) {
            let replyText = SantaDialogueManager.shared.getSantaReply(
                input: clean,
                childName: childName,
                wishlist: wishlist
            )
            let santaMsg = ChatMessage(
                sender: "Santa Claus",
                text: replyText,
                isFromSanta: true
            )
            messages.append(santaMsg)
            preferencesService.saveChatMessages(messages)
            isSantaTyping = false
        }
    }
}
