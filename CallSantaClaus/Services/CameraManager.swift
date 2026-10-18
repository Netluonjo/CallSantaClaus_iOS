import Foundation
import AVFoundation
import SwiftUI

public final class CameraManager: NSObject, ObservableObject {
    @Published public var session = AVCaptureSession()
    @Published public var isCameraAuthorized: Bool = false
    @Published public var isFrontCamera: Bool = true
    
    private var videoDeviceInput: AVCaptureDeviceInput?
    private let sessionQueue = DispatchQueue(label: "com.festive.santacall.cameraSession")
    
    public override init() {
        super.init()
        checkPermissions()
    }
    
    public func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            isCameraAuthorized = true
            setupSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    self?.isCameraAuthorized = granted
                    if granted {
                        self?.setupSession()
                    }
                }
            }
        default:
            isCameraAuthorized = false
        }
    }
    
    public func setupSession() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            self.session.beginConfiguration()
            self.session.sessionPreset = .vga640x480
            
            let position: AVCaptureDevice.Position = self.isFrontCamera ? .front : .back
            guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position),
                  let input = try? AVCaptureDeviceInput(device: camera) else {
                self.session.commitConfiguration()
                return
            }
            
            if self.session.canAddInput(input) {
                self.session.addInput(input)
                self.videoDeviceInput = input
            }
            
            self.session.commitConfiguration()
            self.startSession()
        }
    }
    
    public func startSession() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            if !self.session.isRunning {
                self.session.startRunning()
            }
        }
    }
    
    public func stopSession() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }
    
    public func flipCamera() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            self.session.beginConfiguration()
            
            if let currentInput = self.videoDeviceInput {
                self.session.removeInput(currentInput)
            }
            
            let newPosition: AVCaptureDevice.Position = self.isFrontCamera ? .back : .front
            guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: newPosition),
                  let newInput = try? AVCaptureDeviceInput(device: camera) else {
                self.session.commitConfiguration()
                return
            }
            
            if self.session.canAddInput(newInput) {
                self.session.addInput(newInput)
                self.videoDeviceInput = newInput
                DispatchQueue.main.async {
                    self.isFrontCamera.toggle()
                }
            }
            
            self.session.commitConfiguration()
        }
    }
}
