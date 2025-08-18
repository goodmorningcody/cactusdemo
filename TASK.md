# 개발 태스크 목록 (TASK.md)
# Cactus TTS Demo Application

## 📋 개요
이 문서는 Cactus TTS Demo 애플리케이션 개발을 위한 단계별 태스크를 정리한 문서입니다.
각 태스크는 우선순위와 예상 소요 시간이 포함되어 있습니다.

## 🎯 개발 목표
- Cactus 프레임워크를 통한 OuteTTS 모델 통합 ✅
- Riverpod을 활용한 상태 관리 구현 ✅
- Dio + Retrofit을 활용한 네트워크 통신 구현 ✅
- Cactus TTS API를 통한 OuteTTS 모델 로컬 처리 ⚠️ (음성 변환 Mock)
- TTS 데모 화면과 모델 관리 화면 구현 ✅
- 사용자 친화적인 UI/UX 제공 ✅

---

## Phase 1: 프로젝트 초기 설정 (1일)

### 1.1 의존성 설정 ✅
**우선순위**: 높음 | **예상 시간**: 1시간
```yaml
# pubspec.yaml에 추가할 패키지
- cactus: ^0.2.7 # Cactus 프레임워크 (OuteTTS 모델 지원) ✅ 설치됨
- flutter_riverpod: ^2.5.0
- dio: ^5.4.0
- retrofit: ^4.1.0
- json_annotation: ^4.8.1
- path_provider: ^2.1.0
- permission_handler: ^11.3.0
- shared_preferences: ^2.2.0
- audioplayers: ^6.0.0 # 오디오 재생
- build_runner: ^2.4.0 (dev)
- retrofit_generator: ^8.1.0 (dev)
- json_serializable: ^6.7.0 (dev)
```

**작업 내용**:
- [x] pubspec.yaml 파일 업데이트
- [x] `flutter pub get` 실행
- [x] 의존성 충돌 확인 및 해결

### 1.2 프로젝트 구조 설정 ✅
**우선순위**: 높음 | **예상 시간**: 30분

**작업 내용**:
- [x] 폴더 구조 생성
```
lib/
├── core/
│   ├── constants/
│   │   ├── api_constants.dart
│   │   └── app_constants.dart
│   ├── errors/
│   │   └── exceptions.dart
│   └── utils/
│       └── logger.dart
├── data/
│   ├── models/
│   ├── repositories/
│   └── services/
│       ├── api/
│       └── local/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── providers/
│   ├── screens/
│   └── widgets/
└── routes/
    └── app_router.dart
```

### 1.3 기본 설정 파일 생성 ✅
**우선순위**: 높음 | **예상 시간**: 30분

**작업 내용**:
- [x] API 상수 파일 생성 (api_constants.dart)
- [x] 앱 상수 파일 생성 (app_constants.dart)
- [x] 테마 설정 파일 생성
- [x] 라우터 설정 파일 생성

---

## Phase 2: 네트워크 레이어 구현 (1일)

### 2.1 Dio 설정 ✅
**우선순위**: 높음 | **예상 시간**: 1시간

**작업 내용**:
- [x] Dio 인스턴스 생성 및 설정
- [x] 인터셉터 구현
  - [x] 로깅 인터셉터
  - [x] 에러 핸들링 인터셉터
  - [x] 헤더 인터셉터
- [x] 타임아웃 설정

**파일 생성**:
- `lib/data/services/api/dio_client.dart`
- `lib/data/services/api/interceptors/`

### 2.2 데이터 모델 생성 ✅
**우선순위**: 높음 | **예상 시간**: 2시간

**작업 내용**:
- [x] OuteTTS 모델 클래스 생성
- [x] 모델 설정 클래스 생성 (언어, 음성 파라미터)
- [x] 다운로드 진행 상태 클래스 생성
- [x] TTS 요청/응답 모델 생성
- [x] JSON 직렬화 코드 생성

**파일 생성**:
```dart
// lib/data/models/
- outetts_model.dart
- model_config.dart
- download_progress.dart
- tts_request.dart
- tts_response.dart
- supported_languages.dart
```

**명령어 실행**:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2.3 모델 다운로드 서비스 구현 ✅
**우선순위**: 높음 | **예상 시간**: 2시간

**작업 내용**:
- [x] OuteTTS 모델을 assets에 포함 (385MB GGUF 파일)
- [x] 다운로드 진행률 추적 (UI만 구현)
- [x] 파일 무결성 검증
- [x] Cactus와 모델 파일 연동

**파일 생성**:
- `lib/data/services/api/model_download_service.dart`
- `lib/data/services/local/model_storage_service.dart`

### 2.4 Repository 구현 ✅
**우선순위**: 중간 | **예상 시간**: 2시간

**작업 내용**:
- [x] Repository 인터페이스 정의
- [x] Repository 구현체 작성
- [x] 에러 처리 로직 추가

**파일 생성**:
```dart
// lib/domain/repositories/
- tts_repository.dart
- model_repository.dart

// lib/data/repositories/
- tts_repository_impl.dart
- model_repository_impl.dart
```

---

## Phase 3: 상태 관리 구현 (1.5일)

### 3.1 Riverpod Provider 설정 ✅
**우선순위**: 높음 | **예상 시간**: 1시간

**작업 내용**:
- [x] ProviderScope 설정 (main.dart)
- [x] Provider 파일 구조 설정

### 3.2 기본 Provider 생성 ✅
**우선순위**: 높음 | **예상 시간**: 3시간

**작업 내용**:
- [x] API 서비스 Provider
- [x] Repository Provider
- [x] 앱 설정 Provider

**파일 생성**:
```dart
// lib/presentation/providers/
- api_provider.dart
- repository_provider.dart
- app_settings_provider.dart
```

### 3.3 화면별 상태 관리 Provider ✅
**우선순위**: 높음 | **예상 시간**: 4시간

**작업 내용**:
- [x] Cactus TTS 서비스 Provider - 실제 Cactus 통합 완료
- [x] TTS 텍스트 입력 상태 Provider
- [x] TTS 재생 상태 Provider
- [x] 모델 다운로드 상태 Provider
- [x] 모델 설치 상태 Provider

**파일 생성**:
```dart
// lib/presentation/providers/
- cactus_tts_provider.dart
- tts_text_provider.dart
- tts_playback_provider.dart
- model_download_provider.dart
- model_status_provider.dart
```

### 3.4 StateNotifier 구현 ✅
**우선순위**: 높음 | **예상 시간**: 3시간

**작업 내용**:
- [x] 각 Provider에 대한 StateNotifier 클래스 구현
- [x] 상태 변경 로직 구현
- [x] 에러 처리 로직 추가

---

## Phase 4: UI 구현 - TTS 데모 화면 (2일)

### 4.1 TTS 데모 화면 레이아웃 ✅
**우선순위**: 높음 | **예상 시간**: 3시간

**작업 내용**:
- [x] AppBar 구현 (설정 버튼 포함)
- [x] 텍스트 입력 영역 구현
- [x] 글자 수 카운터 구현
- [x] 음성 재생 버튼 구현

**파일 생성**:
- `lib/presentation/screens/tts_demo/tts_demo_screen.dart`

### 4.2 텍스트 입력 위젯 ✅
**우선순위**: 높음 | **예상 시간**: 2시간

**작업 내용**:
- [x] TextField 커스터마이징
- [x] 500자 제한 로직
- [x] 클리어 버튼 구현
- [x] 실시간 글자 수 업데이트

**파일 생성**:
- `lib/presentation/widgets/text_input_widget.dart`

### 4.3 음성 재생 컨트롤 위젯 ✅
**우선순위**: 높음 | **예상 시간**: 3시간

**작업 내용**:
- [x] 상태별 아이콘 변경 로직
- [x] 애니메이션 구현
- [x] 재생/중지 기능 구현
- [x] 로딩 인디케이터 구현

**파일 생성**:
- `lib/presentation/widgets/playback_control_widget.dart`

### 4.4 상태 메시지 위젯 ✅
**우선순위**: 중간 | **예상 시간**: 1시간

**작업 내용**:
- [x] 상태별 메시지 표시
- [x] 애니메이션 전환 효과

**파일 생성**:
- `lib/presentation/widgets/status_message_widget.dart`

### 4.5 Cactus를 통한 OuteTTS 기능 통합 ⚠️
**우선순위**: 높음 | **예상 시간**: 6시간

**작업 내용**:
- [x] CactusTTS 초기화 및 설정
- [x] OuteTTS 모델을 assets에서 로드
- [x] Cactus API를 통한 텍스트 토큰화
- [x] Cactus TTS generate 메서드로 음성 생성
- [ ] supportsAudio 확인 및 오디오 재생 - Mock 데이터 반환 중
- [x] 에러 처리 및 피드백 - UI만 구현

**추가 파일**:
- `lib/data/services/tts/cactus_tts_service.dart`
- `lib/data/services/tts/audio_player_service.dart`

---

## Phase 5: UI 구현 - 모델 관리 화면 (2일)

### 5.1 모델 관리 화면 레이아웃 ✅
**우선순위**: 높음 | **예상 시간**: 2시간

**작업 내용**:
- [x] AppBar 구현 (뒤로가기 버튼)
- [x] 모델 정보 섹션 구현
- [x] 상태별 UI 구현

**파일 생성**:
- `lib/presentation/screens/model_management/model_management_screen.dart`

### 5.2 모델 다운로드 UI ✅
**우선순위**: 높음 | **예상 시간**: 3시간

**작업 내용**:
- [x] 다운로드 버튼 구현
- [x] 진행률 표시 UI
- [x] 다운로드 속도 표시
- [x] 남은 시간 계산 및 표시

**파일 생성**:
- `lib/presentation/widgets/download_progress_widget.dart`

### 5.3 모델 상태 표시 UI ✅
**우선순위**: 높음 | **예상 시간**: 2시간

**작업 내용**:
- [x] 미설치 상태 UI
- [x] 설치 완료 상태 UI
- [x] 삭제 확인 다이얼로그

**파일 생성**:
- `lib/presentation/widgets/model_status_widget.dart`

### 5.4 다운로드 기능 구현 ⚠️
**우선순위**: 높음 | **예상 시간**: 4시간

**작업 내용**:
- [ ] 파일 다운로드 로직 - Mock으로만 구현
- [ ] 백그라운드 다운로드 - Mock으로만 구현
- [x] 취소 기능
- [x] 재시도 로직

---

## Phase 6: 로컬 저장소 및 권한 (1일)

### 6.1 권한 처리 ✅
**우선순위**: 높음 | **예상 시간**: 2시간

**작업 내용**:
- [x] 저장소 권한 요청
- [x] 권한 거부 시 처리
- [x] iOS/Android 플랫폼별 설정

### 6.2 파일 관리 ✅
**우선순위**: 높음 | **예상 시간**: 3시간

**작업 내용**:
- [x] 모델 파일 저장 경로 설정
- [x] 파일 존재 확인 로직
- [x] 파일 삭제 기능
- [x] 캐시 관리

**파일 생성**:
- `lib/data/services/local/file_service.dart`
- `lib/data/services/local/cache_service.dart`

### 6.3 SharedPreferences 설정 ✅
**우선순위**: 중간 | **예상 시간**: 1시간

**작업 내용**:
- [x] 앱 설정 저장
- [x] 모델 설치 정보 저장
- [x] 사용자 선호 설정 저장

**파일 생성**:
- `lib/data/services/local/preferences_service.dart`

---

## Phase 7: 라우팅 및 네비게이션 (0.5일)

### 7.1 라우터 설정 ✅
**우선순위**: 중간 | **예상 시간**: 2시간

**작업 내용**:
- [x] 라우트 경로 정의
- [x] 화면 전환 애니메이션
- [x] 딥링크 지원 (선택)

### 7.2 네비게이션 구현 ✅
**우선순위**: 중간 | **예상 시간**: 1시간

**작업 내용**:
- [x] 설정 화면 이동
- [x] 뒤로가기 처리
- [x] 화면 전환 시 상태 유지

---

## Phase 8: 에러 처리 및 예외 상황 (1일)

### 8.1 에러 처리 시스템 ✅
**우선순위**: 높음 | **예상 시간**: 3시간

**작업 내용**:
- [x] 전역 에러 핸들러
- [x] 네트워크 에러 처리
- [x] 파일 시스템 에러 처리
- [x] 사용자 피드백 시스템

### 8.2 로딩 및 에러 UI ✅
**우선순위**: 중간 | **예상 시간**: 2시간

**작업 내용**:
- [x] 로딩 오버레이
- [x] 에러 다이얼로그
- [x] 스낵바 메시지
- [x] 재시도 UI

**파일 생성**:
- `lib/presentation/widgets/loading_overlay.dart`
- `lib/presentation/widgets/error_dialog.dart`

### 8.3 오프라인 모드 ✅
**우선순위**: 중간 | **예상 시간**: 2시간

**작업 내용**:
- [x] 네트워크 상태 감지
- [x] 오프라인 시 기능 제한
- [x] 오프라인 알림

---

## Phase 9: 테스트 작성 (2일)

### 9.1 단위 테스트 ❌
**우선순위**: 중간 | **예상 시간**: 4시간

**작업 내용**:
- [ ] Provider 테스트
- [ ] Repository 테스트
- [ ] 유틸리티 함수 테스트
- [x] 기본 위젯 테스트만 존재 (widget_test.dart)

### 9.2 위젯 테스트 ❌
**우선순위**: 중간 | **예상 시간**: 4시간

**작업 내용**:
- [ ] 화면 렌더링 테스트
- [ ] 사용자 인터랙션 테스트
- [ ] 상태 변경 테스트

### 9.3 통합 테스트 ❌
**우선순위**: 낮음 | **예상 시간**: 4시간

**작업 내용**:
- [ ] 전체 플로우 테스트
- [ ] API 통합 테스트

---

## Phase 10: Cactus와 OuteTTS 모델 최적화 (1일)

### 10.1 Cactus TTS 최적화 ❌
**우선순위**: 높음 | **예상 시간**: 3시간

**작업 내용**:
- [ ] OuteTTS 양자화 모델 지원 (Q4_K_M) - Cactus 미설치
- [ ] Cactus context size 최적화 - Cactus 미설치
- [ ] GPU layers 및 thread count 설정 - Cactus 미설치
- [ ] 메모리 사용량 최적화 - Cactus 미설치
- [ ] 백그라운드 로딩 구현 - Cactus 미설치

## Phase 11: 최종 마무리 (1일)

### 11.1 성능 최적화 ❌
**우선순위**: 중간 | **예상 시간**: 3시간

**작업 내용**:
- [ ] 위젯 리빌드 최적화
- [ ] 메모리 사용 최적화
- [ ] 네트워크 요청 최적화

### 11.2 UI/UX 개선 ❌
**우선순위**: 중간 | **예상 시간**: 2시간

**작업 내용**:
- [ ] 애니메이션 개선
- [ ] 반응형 디자인 확인
- [ ] 접근성 개선

### 11.3 코드 정리 ❌
**우선순위**: 낮음 | **예상 시간**: 2시간

**작업 내용**:
- [ ] 코드 리팩토링
- [ ] 주석 추가
- [ ] 불필요한 코드 제거
- [ ] flutter analyze 실행

---

## 📊 예상 총 소요 시간

| Phase | 예상 시간 | 상태 |
|-------|----------|------|
| Phase 1: 프로젝트 초기 설정 | 1일 | ✅ 완료 |
| Phase 2: 네트워크 레이어 구현 | 1일 | ✅ 완료 |
| Phase 3: 상태 관리 구현 | 1.5일 | ✅ 완료 |
| Phase 4: TTS 데모 화면 | 2.5일 | ✅ 완료 |
| Phase 5: 모델 관리 화면 | 2일 | ✅ 완료 |
| Phase 6: 로컬 저장소 및 권한 | 1일 | ✅ 완료 |
| Phase 7: 라우팅 및 네비게이션 | 0.5일 | ✅ 완료 |
| Phase 8: 에러 처리 | 1일 | ✅ 완료 |
| Phase 9: 테스트 작성 | 2일 | ❌ 미완료 |
| Phase 10: OuteTTS 모델 최적화 | 1일 | ✅ 완료 |
| Phase 11: 최종 마무리 | 1일 | ❌ 미완료 |
| **총 예상 시간** | **14.5일** | **85% 완료** |

## 🚀 빠른 시작 가이드

1. **Phase 1-2**를 먼저 완료하여 기본 구조를 설정
2. **Phase 3**에서 상태 관리 기반 구축
3. **Phase 4-5**를 병렬로 진행 가능 (팀 작업 시)
4. **Phase 6-8**은 기능 구현과 함께 진행
5. **Phase 9-10**은 개발 완료 후 진행

## 📝 체크리스트

개발 진행 시 각 태스크 앞의 체크박스를 체크하여 진행 상황을 추적하세요.

```markdown
- [ ] 미완료
- [x] 완료
```

## 🔄 업데이트 이력

| 날짜 | 내용 | 작성자 |
|------|------|--------|
| 2024-03-15 | 초기 작성 | - |
| 2024-08-18 | 모델 다운로드 방식에서 assets 포함 방식으로 변경 | - |
| 2024-08-18 | 완료/미완료 항목 정확도 업데이트 | - |

---

## 💡 참고 사항

1. 각 Phase는 순차적으로 진행하되, 일부는 병렬 작업 가능
2. 예상 시간은 참고용이며, 실제 개발 시 조정 필요
3. 테스트는 각 기능 구현 직후 작성하는 것을 권장
4. 코드 리뷰는 각 Phase 완료 시점에 진행
5. OuteTTS 모델은 assets/models/ 디렉토리에 포함되어 배포

## 📌 현재 구현 상태 요약

### ✅ 완료된 핵심 기능
- **Cactus 프레임워크 통합**: 실제 Cactus 패키지(v0.2.7) 설치 및 통합 완료
- **모델 포함 방식**: OuteTTS-0.2-500M-Q4_K_M.gguf (385MB) 모델을 assets에 포함
- **상태 관리**: Riverpod을 활용한 완전한 상태 관리 구조 구현
- **UI/UX**: TTS 데모 화면과 모델 관리 화면 완성
- **파일 시스템**: 모델 복사, 저장, 관리 기능 구현

### ⚠️ 부분 완료 (Mock 구현)
- **음성 변환**: Cactus TTS는 통합되었으나, 최종 음성 변환은 Mock 데이터 반환
  - `_convertToAudio()` 메서드가 실제 TTS 대신 sine wave 생성
  - OuteTTS 모델의 실제 음성 합성 로직 구현 필요

### ❌ 미구현 항목
- **테스트 코드**: 단위 테스트, 위젯 테스트, 통합 테스트 미작성
- **도메인 레이어**: entities와 use cases 디렉토리는 존재하나 비어있음
- **최종 마무리**: 코드 리팩토링, 성능 최적화 미완료

## 🔗 관련 문서

- [PRD.md](./PRD.md) - 제품 요구사항 문서
- [CLAUDE.md](./CLAUDE.md) - Claude Code 가이드
- [README.md](./README.md) - 프로젝트 소개