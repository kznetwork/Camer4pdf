# Scan4PDF 개발 가이드

## 🏗 개발 환경 설정

### Flutter 설치
```bash
# Flutter SDK 다운로드
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# 설치 확인
flutter doctor
```

### IDE 설정

#### VS Code
1. Extensions 설치
   - Flutter
   - Dart
   - Flutter Widget Snippets

2. settings.json 설정
```json
{
  "dart.flutterSdkPath": "/path/to/flutter",
  "editor.formatOnSave": true,
  "dart.lineLength": 100
}
```

#### Android Studio
1. Plugins 설치
   - Flutter
   - Dart

---

## 🎨 아키텍처

### State Management: Provider

```dart
// AppState - 전역 상태 관리
class AppState extends ChangeNotifier {
  File? _capturedImage;
  
  void setCapturedImage(File? image) {
    _capturedImage = image;
    notifyListeners();  // UI 업데이트
  }
}
```

### 화면 구조

```
CameraScreen (카메라 촬영)
    ↓
PreviewScreen (이미지 미리보기)
    ↓
[저장] or [PDF 변환]
```

---

## 📦 주요 패키지 사용법

### Camera 패키지
```dart
// 카메라 초기화
final cameras = await availableCameras();
final controller = CameraController(
  cameras.first,
  ResolutionPreset.high,
);
await controller.initialize();

// 사진 촬영
final image = await controller.takePicture();
```

### PDF 생성
```dart
import 'package:pdf/widgets.dart' as pw;

final pdf = pw.Document();
pdf.addPage(
  pw.Page(
    build: (context) => pw.Image(
      pw.MemoryImage(imageBytes),
    ),
  ),
);
await file.writeAsBytes(await pdf.save());
```

### 권한 관리
```dart
import 'package:permission_handler/permission_handler.dart';

final status = await Permission.camera.request();
if (status.isGranted) {
  // 카메라 사용 가능
}
```

---

## 🔧 디버깅

### 로그 출력
```dart
import 'package:flutter/foundation.dart';

debugPrint('디버그 메시지');
print('일반 로그');
```

### Flutter DevTools
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

### 디버그 모드 실행
```bash
# Hot Reload 사용 가능
flutter run

# 상세 로그
flutter run -v
```

---

## 🧪 테스트

### 단위 테스트
```dart
// test/utils/pdf_generator_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:scan4pdf/utils/pdf_generator.dart';

void main() {
  test('PDF 생성 테스트', () async {
    // 테스트 코드
  });
}
```

### 위젯 테스트
```dart
testWidgets('카메라 버튼 테스트', (WidgetTester tester) async {
  await tester.pumpWidget(MyApp());
  expect(find.byIcon(Icons.camera), findsOneWidget);
});
```

---

## 🚀 배포

### iOS 배포 (App Store)

1. **Apple Developer 계정 준비**

2. **Bundle ID 설정**
   ```
   com.kzn.scan4pdf
   ```

3. **서명 설정**
   - Xcode에서 Signing & Capabilities 설정

4. **빌드**
   ```bash
   flutter build ios --release
   ```

5. **App Store Connect 업로드**
   ```bash
   open build/ios/archive/Runner.xcarchive
   ```

### Android 배포 (Google Play)

1. **키스토어 생성**
   ```bash
   keytool -genkey -v -keystore scan4pdf.jks \
     -keyalg RSA -keysize 2048 -validity 10000 \
     -alias scan4pdf
   ```

2. **android/key.properties 생성**
   ```properties
   storePassword=<password>
   keyPassword=<password>
   keyAlias=scan4pdf
   storeFile=scan4pdf.jks
   ```

3. **빌드**
   ```bash
   flutter build appbundle --release
   ```

4. **Google Play Console 업로드**

---

## 📊 성능 최적화

### 이미지 최적화
```dart
import 'package:image/image.dart' as img;

// 이미지 리사이즈
final image = img.decodeImage(bytes);
final resized = img.copyResize(image, width: 1920);
```

### 메모리 관리
```dart
@override
void dispose() {
  _controller?.dispose();
  super.dispose();
}
```

### 빌드 최적화
```dart
// const 생성자 사용
const Text('Hello');

// ListView.builder 사용 (많은 항목일 때)
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
);
```

---

## 🐛 일반적인 문제 해결

### 1. 카메라 권한 문제

**증상**: 카메라가 실행되지 않음

**해결**:
- iOS: Info.plist에 권한 설명 추가 확인
- Android: AndroidManifest.xml 권한 확인

### 2. PDF 저장 실패

**증상**: PDF 파일이 생성되지 않음

**해결**:
- 저장소 권한 확인
- 파일 경로 유효성 확인
- 로그 확인

### 3. Hot Reload 문제

**해결**:
```bash
# 전체 재시작
flutter run
# 또는 'R' 키 입력
```

---

## 📝 코딩 컨벤션

### Dart 스타일 가이드
- 변수명: lowerCamelCase
- 클래스명: UpperCamelCase
- 상수명: lowerCamelCase
- 파일명: snake_case

### 예시
```dart
// 좋은 예
class UserProfile {}
final userName = 'John';
const maxRetryCount = 3;

// 나쁜 예
class user_profile {}
final UserName = 'John';
const MAX_RETRY_COUNT = 3;
```

### 주석
```dart
/// 문서화 주석 (공개 API)
/// 
/// [parameter]에 대한 설명
void publicMethod(String parameter) {}

// 일반 주석 (내부 구현)
void _privateMethod() {
  // 구현 내용
}
```

---

## 🔄 Git 워크플로우

### 브랜치 전략
```
main (프로덕션)
  ↑
develop (개발)
  ↑
feature/기능명 (기능 개발)
```

### 커밋 메시지
```
feat: 새로운 기능 추가
fix: 버그 수정
docs: 문서 수정
style: 코드 포맷팅
refactor: 코드 리팩토링
test: 테스트 코드
chore: 빌드 설정 등
```

---

## 📚 참고 자료

- [Flutter 공식 문서](https://flutter.dev/docs)
- [Dart 언어 가이드](https://dart.dev/guides)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Flutter Widget Catalog](https://flutter.dev/docs/development/ui/widgets)

---

**Happy Coding! 🚀**

