# Scan4PDF - Cross-Platform Document Scanner

<div align="center">
  <h3>📸 Scan anything, Save as PDF</h3>
  <p>iOS와 Android를 지원하는 크로스플랫폼 문서 스캐너 앱</p>
</div>

---

## 📱 지원 플랫폼

- ✅ iOS 12.0+
- ✅ Android 5.0+ (API 21+)

---

## ✨ 주요 기능

### 📷 카메라 스캔
- 전면/후면 카메라 전환
- 고화질 사진 촬영
- 실시간 카메라 프리뷰

### 💾 저장 기능
- 갤러리에 이미지 저장
- PDF 파일로 변환 및 저장
- 파일 앱을 통한 PDF 접근

### 🎨 사용자 경험
- 직관적인 UI/UX
- Material Design 3 적용
- 다크 모드 지원
- 부드러운 애니메이션

---

## 🛠 기술 스택

### Framework
- **Flutter** 3.0+
- **Dart** 3.0+

### 주요 패키지
- `camera`: 카메라 기능
- `pdf`: PDF 생성
- `image_gallery_saver`: 갤러리 저장
- `permission_handler`: 권한 관리
- `provider`: 상태 관리
- `path_provider`: 파일 경로 관리

---

## 🚀 시작하기

### 사전 요구사항

1. **Flutter SDK 설치**
   ```bash
   # Flutter 설치 확인
   flutter --version
   ```

2. **플랫폼별 개발 환경**
   - **iOS**: Xcode 14.0+, CocoaPods
   - **Android**: Android Studio, JDK 11+

### 설치 및 실행

1. **저장소 클론**
   ```bash
   git clone https://github.com/kznetwork/Scan4pdf.git
   cd Scan4pdf/flutter_scan4pdf
   ```

2. **의존성 설치**
   ```bash
   flutter pub get
   ```

3. **iOS 설정** (macOS에서만)
   ```bash
   cd ios
   pod install
   cd ..
   ```

4. **앱 실행**
   ```bash
   # iOS
   flutter run -d ios
   
   # Android
   flutter run -d android
   ```

---

## 📂 프로젝트 구조

```
flutter_scan4pdf/
├── lib/
│   ├── main.dart                 # 앱 진입점
│   ├── screens/
│   │   ├── camera_screen.dart    # 카메라 화면
│   │   └── preview_screen.dart   # 미리보기 화면
│   ├── utils/
│   │   ├── app_state.dart        # 앱 상태 관리
│   │   ├── permissions.dart      # 권한 관리
│   │   └── pdf_generator.dart    # PDF 생성
│   └── widgets/
├── android/                       # Android 네이티브 설정
├── ios/                          # iOS 네이티브 설정
├── assets/                       # 이미지, 폰트 등
└── pubspec.yaml                  # 패키지 설정
```

---

## 🔐 권한 설정

### iOS (Info.plist)
```xml
<key>NSCameraUsageDescription</key>
<string>사진을 촬영하기 위해 카메라 접근 권한이 필요합니다.</string>

<key>NSPhotoLibraryAddUsageDescription</key>
<string>촬영한 사진을 저장하기 위해 사진 라이브러리 접근 권한이 필요합니다.</string>
```

### Android (AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
```

---

## 📖 사용 방법

### 1. 문서 스캔
1. 앱 실행
2. 카메라 권한 허용
3. 촬영 버튼 탭 (하단 중앙 흰색 원)

### 2. 이미지 저장
1. 미리보기 화면에서 **저장** 버튼 탭
2. 갤러리 앱에서 확인 가능

### 3. PDF로 변환
1. 미리보기 화면에서 **PDF** 버튼 탭
2. 파일 앱 → 내 iPhone/Android → Scan4PDF 폴더에서 확인

### 4. 카메라 전환
- 촬영 화면 좌측 하단 회전 아이콘 탭

---

## 🏗 빌드

### iOS Release 빌드
```bash
flutter build ios --release
```

### Android APK 빌드
```bash
flutter build apk --release
```

### Android App Bundle 빌드
```bash
flutter build appbundle --release
```

---

## 🧪 테스트

```bash
# 단위 테스트
flutter test

# 통합 테스트
flutter test integration_test
```

---

## 🎯 향후 개발 계획

### Phase 1 (현재)
- ✅ 기본 카메라 촬영
- ✅ 이미지 저장
- ✅ PDF 변환

### Phase 2
- [ ] 여러 이미지를 하나의 PDF로 결합
- [ ] 이미지 편집 (회전, 크롭, 필터)
- [ ] PDF 파일명 커스터마이징

### Phase 3
- [ ] OCR (광학 문자 인식)
- [ ] 문서 자동 가장자리 감지
- [ ] PDF에 텍스트/주석 추가

### Phase 4
- [ ] 클라우드 동기화 (iCloud, Google Drive)
- [ ] PDF 암호화
- [ ] 배치 스캔 모드

---

## 🤝 기여하기

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 라이선스

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

---

## 👨‍💻 개발자

**KZ Network**
- GitHub: [@kznetwork](https://github.com/kznetwork)

---

## 🙏 감사의 말

이 프로젝트는 다음 오픈소스 패키지들을 사용합니다:
- [Flutter](https://flutter.dev)
- [camera](https://pub.dev/packages/camera)
- [pdf](https://pub.dev/packages/pdf)
- [image_gallery_saver](https://pub.dev/packages/image_gallery_saver)
- [permission_handler](https://pub.dev/packages/permission_handler)

---

## 📞 문의

프로젝트에 대한 질문이나 제안사항이 있으시면 이슈를 생성해주세요.

**Happy Scanning! 📸📄**

