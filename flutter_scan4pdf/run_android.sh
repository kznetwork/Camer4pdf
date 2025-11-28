#!/bin/bash

# Android에서 Scan4PDF 실행하기

echo "🚀 Scan4PDF Android 앱 실행 중..."
echo ""

# 프로젝트 디렉토리로 이동
cd "$(dirname "$0")"

# Flutter 설치 확인
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter가 설치되어 있지 않습니다."
    echo "설치 방법: brew install flutter"
    exit 1
fi

# Android 에뮬레이터 확인
if ! adb devices | grep -q "emulator\|device"; then
    echo "⚠️  연결된 Android 디바이스가 없습니다."
    echo "Android Studio에서 에뮬레이터를 실행하거나 디바이스를 연결하세요."
    echo ""
    echo "계속하려면 Enter를 누르세요..."
    read
fi

# 패키지 의존성 확인
echo "📦 Flutter 패키지를 확인합니다..."
flutter pub get

# 앱 실행
echo "✅ 앱을 실행합니다..."
flutter run -d android

echo ""
echo "✨ 완료!"

