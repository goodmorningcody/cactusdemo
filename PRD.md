# Product Requirements Document (PRD)
# Cactus TTS Demo Application

## 1. 제품 개요

### 1.1 제품명
Cactus TTS Demo

### 1.2 제품 설명
Cactus 프레임워크를 통해 OuteTTS 모델을 활용하여 텍스트를 음성으로 변환하는 Flutter 기반 데모 애플리케이션. Cactus는 모바일 디바이스에서 로컬로 AI 모델을 실행하는 크로스 플랫폼 프레임워크입니다.

### 1.3 제품 목적
- Cactus 프레임워크에서 OuteTTS 모델의 TTS 성능과 품질을 시연
- 사용자가 직접 텍스트를 입력하고 음성 변환을 체험할 수 있는 인터페이스 제공
- OuteTTS 모델(GGUF 포맷)의 다운로드 및 관리 기능 제공

### 1.4 타겟 사용자
- TTS 기술에 관심이 있는 개발자
- Cactus TTS 도입을 검토하는 기업 담당자
- 음성 합성 기술을 체험하고자 하는 일반 사용자

## 2. 기능 요구사항

### 2.1 화면 구성

#### 2.1.1 TTS 데모 화면 (메인 화면)
**목적**: 사용자가 텍스트를 입력하고 Cactus 프레임워크를 통해 OuteTTS 모델로 음성 변환하여 재생

**주요 기능**:
- 텍스트 입력 영역
- 음성 재생 컨트롤
- 설정 화면 진입

#### 2.1.2 TTS 모델 관리 화면 (설정 화면)
**목적**: TTS 모델의 다운로드 상태 확인 및 관리

**주요 기능**:
- 모델 다운로드 상태 표시
- 모델 다운로드 기능
- 다운로드 진행률 표시

### 2.2 상세 기능 명세

#### 2.2.1 TTS 데모 화면

**UI 구성 요소**:

1. **앱바 (AppBar)**
   - 제목: "Cactus TTS Demo"
   - 설정 버튼 (우측 상단)
     - 아이콘: settings 아이콘
     - 동작: 탭 시 TTS 모델 관리 화면으로 이동

2. **텍스트 입력 영역**
   - 다중 라인 텍스트 필드
   - 플레이스홀더: "음성으로 변환할 텍스트를 입력하세요"
   - 최대 글자 수: 500자
   - 글자 수 카운터 표시 (우측 하단)
   - 클리어 버튼 (텍스트가 있을 때만 표시)

3. **음성 재생 컨트롤**
   - 보이스 아이콘 버튼
     - 상태별 아이콘:
       - 대기: volume_up 아이콘
       - 재생 중: stop 아이콘
       - 로딩 중: 원형 프로그레스 인디케이터
     - 크기: 64x64 dp
     - 색상: 주 테마 색상

4. **상태 메시지**
   - 위치: 보이스 아이콘 하단
   - 메시지 종류:
     - "텍스트를 입력하고 재생 버튼을 누르세요"
     - "음성 생성 중..."
     - "재생 중..."
     - "모델을 먼저 다운로드하세요"

**기능 동작**:

1. **텍스트 입력**
   - 실시간 글자 수 업데이트
   - 500자 초과 시 입력 제한 및 경고 메시지

2. **음성 재생**
   - 전제 조건:
     - TTS 모델이 다운로드되어 있어야 함
     - 텍스트가 입력되어 있어야 함
   - 동작 플로우:
     1. 보이스 아이콘 탭
     2. 음성 생성 시작 (로딩 표시)
     3. 음성 생성 완료
     4. 자동 재생 시작
     5. 재생 완료 후 초기 상태로 복귀

3. **재생 중지**
   - 재생 중 아이콘 탭 시 즉시 중지
   - 초기 상태로 복귀

#### 2.2.2 TTS 모델 관리 화면

**UI 구성 요소**:

1. **앱바**
   - 제목: "TTS 모델 관리"
   - 뒤로가기 버튼 (좌측)

2. **모델 정보 섹션**
   - 모델 이름: "OuteTTS v0.2 - 500M"
   - 모델 크기: "약 2GB" (GGUF 포맷)
   - 프레임워크: "Cactus TTS 엔진"
   - 지원 언어: 다국어 (한국어, 영어, 일본어, 중국어 등)
   - 현재 상태 표시

3. **상태별 UI**

   **A. 모델 미설치 상태**
   - 상태 아이콘: cloud_download
   - 상태 텍스트: "모델이 설치되지 않았습니다"
   - 다운로드 버튼:
     - 텍스트: "모델 다운로드"
     - 스타일: Elevated Button
     - 색상: 주 테마 색상

   **B. 다운로드 중 상태**
   - 진행률 표시:
     - 원형 프로그레스 인디케이터
     - 백분율 텍스트 (예: "45%")
     - 다운로드 속도 (예: "2.3 MB/s")
     - 남은 시간 (예: "약 30초 남음")
   - 다운로드 크기 정보:
     - "62.5 MB / 150 MB"
   - 취소 버튼:
     - 텍스트: "다운로드 취소"
     - 스타일: Outlined Button

   **C. 모델 설치 완료 상태**
   - 상태 아이콘: check_circle (녹색)
   - 상태 텍스트: "모델이 설치되었습니다"
   - 설치 날짜: "2024년 3월 15일 설치됨"
   - 삭제 버튼:
     - 텍스트: "모델 삭제"
     - 스타일: Text Button
     - 색상: 경고 색상 (빨간색)

4. **추가 정보**
   - 저장 위치 표시
   - 모델 버전 정보
   - 업데이트 확인 버튼 (설치된 경우)

**기능 동작**:

1. **모델 다운로드**
   - 네트워크 연결 확인
   - 저장 공간 확인 (최소 3GB - 모델 크기 + 여유 공간)
   - 다운로드 시작:
     - 백그라운드에서 진행
     - 앱 종료 시에도 계속 진행
   - 진행률 실시간 업데이트
   - 완료 시 자동으로 모델 로드

2. **다운로드 취소**
   - 확인 다이얼로그 표시
   - 취소 확인 시 다운로드 중단
   - 부분 다운로드 파일 삭제

3. **모델 삭제**
   - 확인 다이얼로그 표시:
     - 제목: "모델 삭제"
     - 내용: "OuteTTS 모델을 삭제하시겠습니까? 다시 사용하려면 재다운로드가 필요합니다."
   - 삭제 확인 시 모델 파일 제거
   - 메인 화면으로 자동 이동

## 3. 비기능적 요구사항

### 3.1 성능 요구사항
- TTS 변환 시간: 100자 기준 5초 이내 (Cactus 로컬 처리)
- 음성 재생 지연: 500ms 이내
- 앱 시작 시간: 2초 이내
- OuteTTS 모델 로딩 시간: 5초 이내 (Cactus 최적화)

### 3.2 사용성 요구사항
- 직관적인 UI/UX 디자인
- 한 손 조작 가능한 버튼 배치
- 명확한 상태 피드백 제공
- 오류 발생 시 사용자 친화적 메시지 표시

### 3.3 호환성 요구사항
- Android: 최소 API 레벨 23 (Android 6.0)
- iOS: 최소 iOS 12.0
- 화면 크기: 4.7인치 ~ 태블릿 지원
- 가로/세로 모드 지원

### 3.4 보안 요구사항
- HTTPS를 통한 모델 다운로드
- 다운로드 파일 무결성 검증 (체크섬)
- 로컬 저장 시 앱 전용 디렉토리 사용

## 4. 기술 사양

### 4.1 개발 환경
- Framework: Flutter 3.x
- Language: Dart 3.x
- 상태 관리: Riverpod

### 4.2 주요 패키지
- TTS 프레임워크: cactus (OuteTTS 모델 지원)
- 상태 관리: flutter_riverpod
- HTTP 통신: dio, retrofit, retrofit_generator
- JSON 직렬화: json_serializable, json_annotation
- 파일 관리: path_provider
- 권한 관리: permission_handler
- 로컬 저장소: shared_preferences

### 4.3 네트워크 아키텍처
- API 클라이언트: Retrofit + Dio
- 인터셉터: 
  - 로깅 인터셉터
  - 에러 핸들링 인터셉터
  - 인증 인터셉터 (필요시)
- 타임아웃 설정:
  - Connection: 30초
  - Receive: 60초
  - Send: 30초

### 4.4 상태 관리 아키텍처
```dart
// Provider 구조 예시
- TTSTextProvider: 입력 텍스트 상태 관리
- TTSPlaybackProvider: 재생 상태 관리
- ModelDownloadProvider: 모델 다운로드 상태 관리
- ModelStatusProvider: 모델 설치 상태 관리
```

### 4.5 데이터 모델
```dart
// 주요 데이터 클래스
- OuteTTSModel: OuteTTS 모델 정보 (이름, 버전, 크기, URL, 포맷)
- ModelConfig: 모델 설정 (언어, 음성 스타일, 속도)
- DownloadProgress: 다운로드 진행 상태
- TTSRequest: TTS 요청 데이터 (텍스트, 언어, 음성 파라미터)
- TTSResponse: TTS 응답 데이터 (오디오 데이터, 포맷)
```

### 4.6 모델 다운로드 및 로컬 처리
```
// Cactus 프레임워크를 통한 OuteTTS 모델 실행
// 모델 다운로드 URL (예시)
MODEL_URL: https://huggingface.co/OuteAI/OuteTTS-0.2-500M-GGUF/resolve/main/

// 모델 파일
- OuteTTS-0.2-500M-FP16.gguf (전체 정밀도)
- OuteTTS-0.2-500M-Q4_K_M.gguf (양자화 버전, 더 작은 크기)

// Cactus TTS 처리 플로우
- CactusTTS 초기화: 모델 URL과 설정 파라미터로 초기화
- 모델 로딩: GGUF 파일을 Cactus가 메모리에 로드
- 텍스트 처리: Cactus API를 통한 토큰화 및 음성 합성
- 오디오 생성: supportsAudio 메서드로 오디오 생성 지원 확인 후 생성
```

### 4.7 폴더 구조
```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   ├── errors/
│   └── utils/
├── data/
│   ├── models/
│   ├── repositories/
│   └── services/
│       ├── api/
│       │   ├── api_client.dart
│       │   └── api_service.dart
│       └── local/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── providers/
│   ├── screens/
│   │   ├── tts_demo/
│   │   └── model_management/
│   └── widgets/
└── routes/
```

## 5. UI/UX 가이드라인

### 5.1 디자인 시스템
- Material Design 3 준수
- 라이트/다크 모드 지원
- 주 색상: Cactus 브랜드 색상
- 폰트: 시스템 기본 폰트

### 5.2 애니메이션
- 화면 전환: 슬라이드 애니메이션
- 버튼 탭: 리플 효과
- 로딩: 부드러운 프로그레스 애니메이션

### 5.3 접근성
- 최소 터치 영역: 48x48 dp
- 충분한 색상 대비
- 스크린 리더 지원
- 폰트 크기 조절 대응

## 6. 에러 처리

### 6.1 네트워크 에러
- Dio 인터셉터를 통한 중앙화된 에러 처리
- 자동 재시도 로직 (최대 3회)
- 사용자 친화적 에러 메시지

### 6.2 저장 공간 부족
- 다운로드 전 공간 확인
- 부족 시 필요 공간 안내

### 6.3 TTS 변환 실패
- 오류 메시지 표시
- 재시도 버튼 제공
- 폴백 처리

## 7. Riverpod Provider 설계

### 7.1 Provider 구조
```dart
// Cactus TTS 서비스 Provider
final cactusTTSProvider = Provider<CactusTTS>((ref) {
  return CactusTTS();
});

// API 서비스 Provider
final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = Dio();
  return ApiService(dio);
});

// 모델 상태 Provider
final modelStatusProvider = StateNotifierProvider<ModelStatusNotifier, ModelStatus>();

// 다운로드 진행 Provider
final downloadProgressProvider = StateNotifierProvider<DownloadProgressNotifier, DownloadProgress>();

// TTS 재생 상태 Provider
final ttsPlaybackProvider = StateNotifierProvider<TTSPlaybackNotifier, TTSPlaybackState>();

// 텍스트 입력 Provider
final inputTextProvider = StateProvider<String>((ref) => '');
```

### 7.2 AsyncValue 활용
- API 호출 시 AsyncValue로 로딩/에러/데이터 상태 관리
- UI에서 when 메서드로 상태별 위젯 렌더링

## 8. 테스트 시나리오

### 8.1 단위 테스트
- Provider 로직 테스트
- API 서비스 모킹 테스트
- 데이터 모델 직렬화 테스트

### 8.2 위젯 테스트
- 화면별 UI 렌더링 테스트
- 사용자 인터랙션 테스트
- Provider 상태 변경 테스트

### 8.3 통합 테스트
- 전체 플로우 테스트
- 네트워크 요청 테스트
- 파일 다운로드 테스트

## 9. 향후 개선 사항

### Phase 2
- 음성 속도 조절
- 음성 톤 선택
- 여러 언어 모델 지원
- 오프라인 모드

### Phase 3
- 음성 파일 저장
- 텍스트 히스토리
- 즐겨찾기 기능
- 배치 처리

## 10. 성공 지표

- 일일 활성 사용자 100명 이상
- 평균 세션 시간 3분 이상
- TTS 변환 성공률 95% 이상
- 앱 크래시율 1% 미만
- 사용자 만족도 4.0/5.0 이상
- API 응답 시간 평균 2초 이내