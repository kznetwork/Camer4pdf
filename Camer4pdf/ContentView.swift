import SwiftUI

struct ContentView: View {
    @StateObject private var cameraManager = CameraManager()
    @State private var showingImagePreview = false
    
    var body: some View {
        ZStack {
            if cameraManager.isAuthorized {
                // 카메라 프리뷰
                CameraView(cameraManager: cameraManager)
                    .ignoresSafeArea()
                    .onAppear {
                        cameraManager.startSession()
                    }
                    .onDisappear {
                        cameraManager.stopSession()
                    }
                
                // 컨트롤 UI
                VStack {
                    Spacer()
                    
                    HStack {
                        // 카메라 전환 버튼
                        Button(action: {
                            cameraManager.switchCamera()
                        }) {
                            Image(systemName: "camera.rotate")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(Color.black.opacity(0.5))
                                .clipShape(Circle())
                        }
                        .padding(.leading, 30)
                        
                        Spacer()
                        
                        // 촬영 버튼
                        Button(action: {
                            cameraManager.capturePhoto()
                        }) {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 70, height: 70)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 3)
                                        .frame(width: 80, height: 80)
                                )
                        }
                        
                        Spacer()
                        
                        // 갤러리 버튼 (미리보기용)
                        Button(action: {
                            if cameraManager.capturedImage != nil {
                                showingImagePreview = true
                            }
                        }) {
                            if let image = cameraManager.capturedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.white, lineWidth: 2)
                                    )
                            } else {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.black.opacity(0.5))
                                    .frame(width: 60, height: 60)
                                    .overlay(
                                        Image(systemName: "photo")
                                            .foregroundColor(.white)
                                    )
                            }
                        }
                        .padding(.trailing, 30)
                    }
                    .padding(.bottom, 50)
                }
            } else {
                // 권한 요청 화면
                VStack(spacing: 20) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text("카메라 접근 권한이 필요합니다")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("설정에서 카메라 권한을 허용해주세요")
                        .font(.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                    if cameraManager.showAlert {
                        Button("설정으로 이동") {
                            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(settingsUrl)
                            }
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
        .sheet(isPresented: $showingImagePreview) {
            if let image = cameraManager.capturedImage {
                ImagePreviewView(image: image, isPresented: $showingImagePreview)
            }
        }
        .onChange(of: cameraManager.capturedImage) { newImage in
            if newImage != nil {
                showingImagePreview = true
            }
        }
    }
}

struct ImagePreviewView: View {
    let image: UIImage
    @Binding var isPresented: Bool
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                
                Spacer()
                
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Spacer()
                
                HStack(spacing: 40) {
                    // 사진 저장 버튼
                    Button(action: {
                        saveImageToGallery()
                    }) {
                        VStack {
                            Image(systemName: "square.and.arrow.down")
                                .font(.system(size: 30))
                            Text("저장")
                                .font(.caption)
                        }
                        .foregroundColor(.white)
                    }
                    
                    // PDF로 내보내기 버튼
                    Button(action: {
                        exportToPDF()
                    }) {
                        VStack {
                            Image(systemName: "doc.fill")
                                .font(.system(size: 30))
                            Text("PDF")
                                .font(.caption)
                        }
                        .foregroundColor(.white)
                    }
                    
                    // 확인 버튼
                    Button(action: {
                        isPresented = false
                    }) {
                        VStack {
                            Image(systemName: "checkmark.circle")
                                .font(.system(size: 30))
                            Text("확인")
                                .font(.caption)
                        }
                        .foregroundColor(.white)
                    }
                }
                .padding(.bottom, 50)
            }
        }
        .alert("알림", isPresented: $showAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func saveImageToGallery() {
        let imageSaver = ImageSaver()
        imageSaver.successHandler = {
            alertMessage = "사진이 갤러리에 저장되었습니다."
            showAlert = true
        }
        imageSaver.errorHandler = { error in
            alertMessage = "저장 실패: \(error.localizedDescription)"
            showAlert = true
        }
        imageSaver.writeToPhotoAlbum(image: image)
    }
    
    private func exportToPDF() {
        print("PDF 내보내기 시작...")
        
        guard let pdfData = PDFGenerator.createPDFData(from: image) else {
            print("PDF 생성 실패")
            alertMessage = "PDF 생성에 실패했습니다."
            showAlert = true
            return
        }
        
        // Documents 폴더에 저장
        let fileName = "Photo_\(Date().timeIntervalSince1970).pdf"
        
        if let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsPath.appendingPathComponent(fileName)
            
            do {
                try pdfData.write(to: fileURL)
                print("PDF 저장 성공: \(fileURL.path)")
                alertMessage = "PDF가 파일 앱에 저장되었습니다.\n파일명: \(fileName)"
                showAlert = true
            } catch {
                print("PDF 저장 실패: \(error.localizedDescription)")
                alertMessage = "PDF 저장에 실패했습니다."
                showAlert = true
            }
        } else {
            alertMessage = "저장 경로를 찾을 수 없습니다."
            showAlert = true
        }
    }
}

// 이미지 저장 헬퍼 클래스
class ImageSaver: NSObject {
    var successHandler: (() -> Void)?
    var errorHandler: ((Error) -> Void)?
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            errorHandler?(error)
        } else {
            successHandler?()
        }
    }
}


#Preview("카메라 뷰") {
    let previewManager = CameraManager(isPreview: true)
    return ContentView()
        .environmentObject(previewManager)
}

#Preview("이미지 프리뷰") {
    ImagePreviewView(
        image: UIImage(systemName: "photo")!,
        isPresented: .constant(true)
    )
}

