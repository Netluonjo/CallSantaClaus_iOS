# 🎅 Santa Call iOS (Mô Phỏng Trò Chuyện & Gọi Điện Cùng Ông Già Noel)

[![iOS](https://img.shields.io/badge/Platform-iOS%2016.0%2B-blue.svg?logo=apple&style=flat-square)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange.svg?logo=swift&style=flat-square)](https://swift.org/)
[![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-red.svg?logo=swift&style=flat-square)](https://developer.apple.com/xcode/swiftui/)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=flat-square)](LICENSE)

Dự án iOS Native hoàn chỉnh mô phỏng cuộc gọi thoại, video FaceTime và nhắn tin thông minh với **Ông Già Noel (Santa Claus)**, thiết kế chuẩn ngôn ngữ giao diện iOS 17/18 với hiệu ứng hạt tuyết rơi 60 FPS lung linh và âm thanh sống động từ xưởng quà Bắc Cực.

---

## 🌟 Tính Năng Nổi Bật (Full Parity với bản Android)

1. **🎄 Giao Diện Banner Chuẩn App Store & iOS:**
   - Banner gradient Giáng Sinh sang trọng (Festive Red & Midnight Navy) kèm hiệu ứng kính mờ `ultraThinMaterial`.
   - Đồng hồ đếm ngược thời gian thực đến Đêm Noel (24/12 20:00) theo từng ngày, giờ, phút, giây.
   - Hiệu ứng hạt tuyết rơi tự nhiên 60 FPS mượt mà sử dụng SwiftUI Canvas.
   - Trạng thái Santa trực tuyến tại Bắc Cực 🟢 với hiệu ứng breathing glow.

2. **📹 Cuộc Gọi Video FaceTime Giả Lập (Fake Video Call):**
   - Video stream Santa Claus tại xưởng quà tuyết trắng Bắc Cực với giọng nói `santa_greeting.wav` chào mừng Giáng Sinh.
   - Khung hình Camera selfie Picture-in-Picture (PiP) của bé bằng `AVFoundation` (`AVCaptureSession` & `AVCaptureVideoPreviewLayer`).
   - Hỗ trợ đổi camera trước/sau (`flipCamera`), bật/tắt micro, loa ngoài và đồng hồ đếm thời gian cuộc gọi.

3. **🎙️ Cuộc Gọi Thoại Sống Động (Fake Voice Call):**
   - Màn hình cuộc gọi chuẩn giao diện Phone iOS với sóng âm thanh `AudioWaveformView` nhảy theo giọng nói Santa.
   - Phím tắt chuyển đổi tức thì sang cuộc gọi Video FaceTime, tắt tiếng, bật loa ngoài.

4. **📲 Màn Hình Cuộc Gọi Đến Siêu Thực (Incoming Call Screen):**
   - Nhạc chuông **Jingle Bells** phòng thu chất lượng cao kết hợp rung nhịp điệu `UINotificationFeedbackGenerator`.
   - Vòng sóng avatar tỏa sáng pulsating, đầy đủ 2 nút "Nghe máy" (xanh neon) và "Từ chối" (đỏ).

5. **💬 Chat Thông Minh iMessage Với Santa (Smart Dialogue Engine):**
   - Khung chat bong bóng iMessage chuẩn Apple, hỗ trợ trạng thái "Santa đang soạn tin nhắn... 🎅".
   - Bộ máy hội thoại tiếng Việt thông minh `SantaDialogueManager` với 20+ danh mục:
     - Chào hỏi, hỏi tuổi, hỏi sức khỏe, thăm hỏi đàn tuần lộc Rudolph mũi đỏ.
     - Kiểm tra danh sách Bé Ngoan, xin quà Noel, hỏi thăm Bà già Noel (Mrs. Claus).
     - Kể chuyện cổ tích, hát bài ca Jingle Bells, chúc ngủ ngon.
     - Dynamic Fallback Pool xoay vòng thông minh, không bao giờ lặp lại câu nhàm chán.
   - Gợi ý câu hỏi nhanh (Suggestion Chips) giúp bé nhắn tin chỉ với 1 chạm.

6. **⏰ Hẹn Giờ Đổ Chuông (Schedule Prank Call):**
   - Hẹn giờ đổ chuông sau 10 giây, 30 giây, 1 phút, 5 phút, 15 phút.
   - Tích hợp `UserNotifications` (`UNUserNotificationCenter`) và bộ hẹn giờ Foreground/Background.

7. **👦 Cá Nhân Hóa Hồ Sơ Bé Ngoan (Child Profile):**
   - Tùy chỉnh tên bé (ví dụ: "Bé Bo", "Minh Anh"), độ tuổi, điều ước quà tặng và lời dặn của Santa.
   - Lưu trữ an toàn và đồng bộ qua `UserDefaults`.

8. **👑 Mô Phỏng Gói VIP Santa Pass:**
   - Màn hình mua in-app phong cách App Store với hiệu ứng mở khóa đặc quyền cho bé.

---

## 📁 Cấu Trúc Dự Án (Architecture)

```text
CallSantaClaus_iOS/
├── CallSantaClaus/
│   ├── App/
│   │   ├── CallSantaClausApp.swift       # Điểm khởi chạy App & cấu hình Environment
│   │   └── Info.plist                    # Cấu hình Camera, Micro, Background Audio
│   ├── Models/
│   │   └── CallModels.swift              # Data model: CallType, ChildProfile, ChatMessage
│   ├── Services/
│   │   ├── PreferencesService.swift      # Quản lý lưu trữ UserDefaults
│   │   ├── SantaDialogueManager.swift    # Bộ não đối thoại tiếng Việt thông minh
│   │   ├── SoundManager.swift            # Quản lý phát nhạc chuông, giọng nói & haptics
│   │   ├── CameraManager.swift           # Quản lý AVFoundation & Selfie PiP Camera
│   │   └── NotificationService.swift     # Xử lý hẹn giờ và Local Notifications
│   ├── Theme/
│   │   ├── ChristmasTheme.swift          # Hệ thống màu sắc HSL, Gradient & Tokens
│   │   └── SnowfallView.swift            # Hiệu ứng hạt tuyết rơi 60 FPS Canvas
│   ├── Views/
│   │   ├── MainDashboardView.swift       # Màn hình chính Dashboard
│   │   ├── IncomingCallView.swift        # Màn hình chuông gọi đến
│   │   ├── VideoCallView.swift           # Cuộc gọi video FaceTime
│   │   ├── VoiceCallView.swift           # Cuộc gọi thoại & sóng âm thanh
│   │   ├── ChatView.swift                # Màn hình chat iMessage với Santa
│   │   └── Components/
│   │       ├── CountdownBannerView.swift # Banner đếm ngược đêm Noel
│   │       ├── AudioWaveformView.swift   # Sóng âm thanh nhấp nháy
│   │       ├── CameraPreviewView.swift   # Khung hiển thị camera bé (UIViewRepresentable)
│   │       ├── ChildProfileSheet.swift   # Sheet chỉnh sửa hồ sơ bé
│   │       ├── ScheduleCallSheet.swift   # Sheet hẹn giờ đổ chuông
│   │       └── VipPassSheet.swift        # Sheet gói VIP Santa
│   ├── Assets.xcassets/                  # Asset catalog chứa AppIcon & hình ảnh Santa
│   └── Resources/                        # Âm thanh wav (santa_greeting, santa_ringtone)
├── CallSantaClaus.xcodeproj/             # File dự án Xcode chuẩn
├── Package.swift                         # Hỗ trợ Swift Package Manager
└── README.md
```

---

## 🚀 Hướng Dẫn Mở & Chạy Dự Án

### 1. Mở Bằng Xcode
1. Mở Xcode trên macOS.
2. Chọn **Open a Project or File** -> Trỏ tới thư mục `CallSantaClaus_iOS` hoặc file `CallSantaClaus.xcodeproj`.
3. Chọn máy ảo iOS Simulator (ví dụ: iPhone 15 Pro, iPhone 16) hoặc thiết bị iPhone thật.
4. Nhấn phím **Cmd + R** để chạy dự án.

### 2. Sử Dụng Swift Package Manager
Dự án được cấu hình sẵn file `Package.swift`, bạn có thể kiểm tra hoặc tích hợp trực tiếp vào bất kỳ Xcode Workspace nào.

---

## 📜 Quyền Riêng Tư & An Toàn Cho Trẻ Em (Child Safety)
- Ứng dụng hoạt động **100% Offline**, không thu thập dữ liệu cá nhân hay tải hình ảnh/video của trẻ lên internet.
- Hình ảnh camera trước chỉ hiển thị cục bộ trên màn hình thiết bị và không bao giờ được ghi lại hay gửi đi.

---

## 🎁 Tác Giả & Bản Quyền
- Phát triển bởi [@Netluonjo](https://github.com/Netluonjo)
- Giáng Sinh An Lành & Merry Christmas! 🎅🎄✨
