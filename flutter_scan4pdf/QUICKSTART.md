# 🚀 Scan4PDF 빠른 실행 가이드

## ⚡️ 가장 빠른 방법

### iOS에서 실행

```bash
cd /Users/kz4/DEV/KZNMultiProject/DemoApp/Camer4pdf/flutter_scan4pdf
./run_ios.sh
```

### Android에서 실행

```bash
cd /Users/kz4/DEV/KZNMultiProject/DemoApp/Camer4pdf/flutter_scan4pdf
./run_android.sh
```

---

## 📋 필수 준비사항

### 1. Flutter SDK 설치

```bash
# Homebrew 사용 (권장)
brew install flutter

# 설치 확인
flutter doctor
```

### 2. Xcode 설치 (iOS 개발용 - macOS만)

1. App Store에서 Xcode 다운로드
2. Command Line Tools 설치:
   ```bash
   xcode-select --install
   sudo xcodebuild -license accept
   ```

### 3. Android Studio 설치 (Android 개발용)

1. [Android Studio 다운로드](https://developer.android.com/studio)
2. Android SDK 설치
3. AVD (Android Virtual Device) 생성

---

## 🎯 단계별 실행 방법

### Step 1: 프로젝트로 이동

```bash
cd /Users/kz4/DEV/KZNMultiProject/DemoApp/Camer4pdf/flutter_scan4pdf
```

### Step 2: 의존성 설치

```bash
flutter pub get
```

### Step 3: iOS Pod 설치 (iOS만, 처음 한 번)

```bash
cd ios
pod install
cd ..
```

### Step 4: 디바이스 실행

**iOS 시뮬레이터:**
```bash
open -a Simulator
```

**Android 에뮬레이터:**
```bash
# Android Studio → Tools → Device Manager → 에뮬레이터 실행
```

### Step 5: 앱 실행

```bash
# iOS
flutter run -d ios

# Android
flutter run -d android

# 자동 선택
flutter run
```

---

## 🎮 실행 중 명령어

앱이 실행되면 터미널에서 사용 가능:

- `r` - Hot Reload (즉시 반영)
- `R` - Hot Restart (앱 재시작)
- `q` - 종료
- `h` - 도움말

---

## 🐛 문제 해결

### 1. "flutter: command not found"

**해결:**
```bash
# Flutter 설치
brew install flutter

# PATH 추가 (zsh)
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.zshrc
source ~/.zshrc

# PATH 추가 (bash)
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bash_profile
source ~/.bash_profile
```

### 2. iOS: "CocoaPods not installed"

**해결:**
```bash
sudo gem install cocoapods
cd ios
pod install
cd ..
```

### 3. Android: "No devices found"

**해결:**
- Android Studio 실행
- Tools → Device Manager
- 에뮬레이터 생성 및 실행

### 4. "Gradle build failed"

**해결:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### 5. 권한 오류 (Permission denied)

**해결:**
```bash
chmod +x run_ios.sh
chmod +x run_android.sh
```

---

## 📱 첫 실행 시 확인사항

### iOS
- ✅ Xcode 설치됨
- ✅ Command Line Tools 설치됨
- ✅ 시뮬레이터 실행 중
- ✅ Pod 설치 완료

### Android
- ✅ Android Studio 설치됨
- ✅ Android SDK 설치됨
- ✅ 에뮬레이터 생성됨
- ✅ 에뮬레이터 실행 중

---

## 🔍 디바이스 확인

```bash
# 연결된 모든 디바이스 확인
flutter devices

# 출력 예시:
# iPhone 15 Pro (mobile) • ios • iOS 17.0
# Pixel 7 (mobile)       • android • Android 14
```

---

## 🎨 첫 실행 화면

앱이 시작되면:

1. **카메라 권한 요청** - "허용" 선택
2. **카메라 화면 표시** - 실시간 프리뷰 보임
3. **촬영 버튼** (흰색 원) - 사진 촬영
4. **미리보기 화면** - 촬영한 사진 확인
5. **저장/PDF 버튼** - 원하는 기능 선택

---

## ⚙️ 추가 설정 (선택)

### VS Code 설정

1. Flutter Extension 설치
2. Dart Extension 설치
3. F5 키로 디버깅 시작

### Android Studio 설정

1. Flutter Plugin 설치
2. Dart Plugin 설치
3. Run 버튼으로 실행

---

## 📊 실행 시간

| 항목 | 시간 |
|------|------|
| 의존성 설치 | ~2분 |
| iOS Pod 설치 | ~3분 |
| 첫 빌드 (iOS) | ~5분 |
| 첫 빌드 (Android) | ~3분 |
| Hot Reload | <1초 |

---

## 🎯 체크리스트

실행 전 확인:

- [ ] Flutter 설치됨 (`flutter --version`)
- [ ] 프로젝트 디렉토리로 이동
- [ ] `flutter pub get` 실행
- [ ] 디바이스/시뮬레이터 실행 중
- [ ] `flutter devices`로 디바이스 확인
- [ ] `flutter run` 실행

---

## 💡 팁

### 빠른 개발을 위한 팁

1. **Hot Reload 활용**
   - 코드 수정 후 `r` 키만 누르면 즉시 반영

2. **디버그 모드**
   - `flutter run -v` (상세 로그)
   - `flutter run --debug` (디버그 모드)

3. **특정 디바이스 지정**
   ```bash
   flutter run -d "iPhone 15 Pro"
   ```

4. **성능 모니터링**
   ```bash
   flutter run --profile
   ```

---

## 📞 추가 도움말

**공식 문서**: https://flutter.dev/docs  
**Flutter Doctor**: `flutter doctor -v` (상세 진단)  
**문제 해결**: https://flutter.dev/docs/get-started/install/macos

---

## ✨ 성공!

앱이 실행되면:
- 📱 디바이스/시뮬레이터에 앱 표시
- 🎥 카메라 프리뷰 작동
- 📸 사진 촬영 가능
- 📄 PDF 변환 가능

**즐거운 개발 되세요! 🚀**

