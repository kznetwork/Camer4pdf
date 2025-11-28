#!/bin/bash

# iOS에서 Scan4PDF 실행하기

echo "🚀 Scan4PDF iOS 앱 실행 중..."
echo ""

# 프로젝트 디렉토리로 이동
cd "$(dirname "$0")"

# Flutter 설치 확인
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter가 설치되어 있지 않습니다."
    echo "설치 방법: brew install flutter"
    exit 1
fi

# iOS 시뮬레이터 확인
if ! xcrun simctl list devices | grep -q "Booted"; then
    echo "📱 iOS 시뮬레이터를 실행합니다..."
    open -a Simulator
    sleep 5
fi

# Pod 설치 (처음 한 번만 필요)
if [ ! -d "ios/Pods" ]; then
    echo "📦 iOS 의존성을 설치합니다..."
    cd ios
    pod install
    cd ..
fi

# 패키지 의존성 확인
echo "📦 Flutter 패키지를 확인합니다..."
flutter pub get

# 앱 실행
echo "✅ 앱을 실행합니다..."
flutter run -d ios

echo ""
echo "✨ 완료!"

