# Camer4pdf - iOS 카메라 앱

Swift와 SwiftUI로 제작된 간단한 iOS 카메라 앱입니다.

## 주요 기능

- 📸 **사진 촬영**: 버튼을 터치하여 사진 촬영
- 👁️ **즉시 미리보기**: 촬영한 사진을 바로 확인
- 🔄 **카메라 전환**: 전면/후면 카메라 전환 가능
- 💾 **사진 저장**: 촬영한 사진을 갤러리에 저장

## 파일 구조

```
Camer4pdf/
├── Camer4pdfApp.swift      # 앱 엔트리 포인트
├── ContentView.swift        # 메인 UI 화면
├── CameraView.swift         # 카메라 프리뷰 뷰
├── CameraManager.swift      # 카메라 세션 관리 클래스
├── Info.plist              # 카메라 권한 설정
└── README.md               # 프로젝트 설명
```

## Xcode 프로젝트 설정 방법

1. **Xcode에서 새 프로젝트 생성**
   - Xcode를 열고 "Create a new Xcode project" 선택
   - iOS > App 템플릿 선택
   - Product Name: `Camer4pdf`
   - Interface: `SwiftUI`
   - Language: `Swift`

2. **파일 추가**
   - 생성된 프로젝트에서 기본 생성된 파일들을 삭제
   - 이 폴더의 모든 `.swift` 파일들을 Xcode 프로젝트에 드래그 앤 드롭

3. **Info.plist 설정**
   - 프로젝트 Navigator에서 프로젝트 선택
   - Targets > Info 탭 선택
   - Custom iOS Target Properties에 다음 키 추가:
     - `Privacy - Camera Usage Description`: "사진을 촬영하기 위해 카메라 접근 권한이 필요합니다."
     - `Privacy - Photo Library Additions Usage Description`: "촬영한 사진을 저장하기 위해 사진 라이브러리 접근 권한이 필요합니다."
   
   또는 제공된 `Info.plist` 파일의 내용을 복사하여 사용

4. **실제 기기에서 실행**
   - 카메라 기능은 시뮬레이터에서 제대로 작동하지 않습니다
   - 실제 iPhone 또는 iPad에서 테스트하세요

## 사용 방법

1. 앱을 실행하면 카메라 권한 요청이 나타납니다
2. "허용"을 선택하면 카메라 프리뷰가 표시됩니다
3. 화면 하단의 흰색 원형 버튼을 터치하여 사진 촬영
4. 촬영된 사진이 자동으로 전체 화면으로 표시됩니다
5. 미리보기 화면에서:
   - "저장" 버튼으로 사진을 갤러리에 저장
   - "확인" 버튼 또는 X 버튼으로 카메라로 돌아가기
6. 왼쪽 하단의 회전 버튼으로 전면/후면 카메라 전환
7. 오른쪽 하단의 썸네일을 터치하여 마지막 촬영 사진 다시 보기

## 기술 스택

- **언어**: Swift
- **UI 프레임워크**: SwiftUI
- **카메라**: AVFoundation
- **최소 iOS 버전**: iOS 15.0+

## 주요 컴포넌트 설명

### CameraManager
- AVFoundation을 사용한 카메라 세션 관리
- 사진 촬영 및 권한 처리
- ObservableObject로 SwiftUI와 연동

### CameraView
- UIViewRepresentable을 통해 UIKit의 AVCaptureVideoPreviewLayer를 SwiftUI에서 사용
- 실시간 카메라 프리뷰 표시

### ContentView
- 메인 UI 구성
- 촬영 버튼, 카메라 전환, 미리보기 등의 인터페이스 제공

### ImagePreviewView
- 촬영한 사진을 전체 화면으로 표시
- 저장 및 확인 기능 제공

## 라이선스

이 프로젝트는 학습 및 개인 사용 목적으로 자유롭게 사용하실 수 있습니다.

