import AVFoundation
import UIKit

class CameraManager: NSObject, ObservableObject {
    @Published var capturedImage: UIImage?
    @Published var isAuthorized = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    let session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private var videoDeviceInput: AVCaptureDeviceInput?
    private var isPreviewMode = false
    
    override init() {
        super.init()
        checkAuthorization()
    }
    
    // Preview용 초기화
    init(isPreview: Bool) {
        self.isPreviewMode = isPreview
        super.init()
        if isPreview {
            isAuthorized = true
        } else {
            checkAuthorization()
        }
    }
    
    func checkAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            isAuthorized = true
            setupCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    self?.isAuthorized = granted
                    if granted {
                        self?.setupCamera()
                    }
                }
            }
        case .denied, .restricted:
            isAuthorized = false
            alertMessage = "카메라 접근 권한이 필요합니다. 설정에서 권한을 허용해주세요."
            showAlert = true
        @unknown default:
            break
        }
    }
    
    func setupCamera() {
        session.beginConfiguration()
        session.sessionPreset = .photo
        
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
              session.canAddInput(videoDeviceInput) else {
            session.commitConfiguration()
            return
        }
        
        self.videoDeviceInput = videoDeviceInput
        session.addInput(videoDeviceInput)
        
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
            photoOutput.maxPhotoQualityPrioritization = .quality
        }
        
        session.commitConfiguration()
    }
    
    func startSession() {
        if !session.isRunning {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.session.startRunning()
            }
        }
    }
    
    func stopSession() {
        if session.isRunning {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.session.stopRunning()
            }
        }
    }
    
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        
        if let photoOutputConnection = photoOutput.connection(with: .video) {
            photoOutputConnection.videoOrientation = .portrait
        }
        
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func switchCamera() {
        guard let currentInput = videoDeviceInput else { return }
        
        session.beginConfiguration()
        session.removeInput(currentInput)
        
        let newPosition: AVCaptureDevice.Position = currentInput.device.position == .back ? .front : .back
        
        guard let newDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: newPosition),
              let newInput = try? AVCaptureDeviceInput(device: newDevice),
              session.canAddInput(newInput) else {
            session.addInput(currentInput)
            session.commitConfiguration()
            return
        }
        
        videoDeviceInput = newInput
        session.addInput(newInput)
        session.commitConfiguration()
    }
}

extension CameraManager: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("사진 촬영 오류: \(error.localizedDescription)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.capturedImage = image
        }
    }
}

