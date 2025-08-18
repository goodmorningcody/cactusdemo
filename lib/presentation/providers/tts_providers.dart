import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/tts_request.dart';
import '../../data/models/tts_response.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/logger.dart';
import '../../domain/repositories/tts_repository.dart';
import 'repository_providers.dart';
import 'model_providers.dart';

// TTS Text Input Provider
final ttsTextProvider = StateProvider<String>((ref) => '');

// TTS Playback State
enum PlaybackState {
  idle,
  loading,
  playing,
  stopped,
  error,
}

// TTS Playback State Notifier
class TTSPlaybackNotifier extends StateNotifier<PlaybackState> {
  final TTSRepository _repository;
  final Ref _ref;
  TTSResponse? _lastResponse;

  TTSPlaybackNotifier(this._repository, this._ref)
      : super(PlaybackState.idle);

  Future<void> generateAndPlay(String text) async {
    if (text.isEmpty) {
      Logger.warning('Cannot generate speech for empty text');
      return;
    }

    if (text.length > AppConstants.maxTextLength) {
      Logger.warning('Text exceeds maximum length');
      return;
    }

    try {
      state = PlaybackState.loading;
      
      // Check if model is loaded
      final isLoaded = await _repository.isModelLoaded();
      if (!isLoaded) {
        // Try to initialize with default model path
        final defaultModel = await _ref.read(defaultModelProvider.future);
        final modelStatusValue = _ref
            .read(modelStatusProvider(defaultModel.id));
        
        final modelStatus = modelStatusValue.maybeWhen(
          data: (status) => status,
          orElse: () => null,
        );
        
        if (modelStatus != null && modelStatus.modelPath != null) {
          await _repository.initializeTTS(modelStatus.modelPath!);
        } else {
          throw Exception('모델이 설치되지 않았습니다');
        }
      }

      // Generate speech
      final request = TTSRequest(
        text: text,
        language: 'ko',
        speed: 1.0,
        pitch: 1.0,
      );
      
      Logger.info('Generating speech for: $text');
      _lastResponse = await _repository.generateSpeech(request);
      
      // Play audio
      if (_lastResponse?.hasAudioData ?? false) {
        state = PlaybackState.playing;
        await _repository.playAudio(_lastResponse!.audioData!);
        
        // Wait for playback to complete
        // In real implementation, this would be event-driven
        await Future.delayed(
          Duration(milliseconds: _lastResponse!.duration),
        );
        
        state = PlaybackState.idle;
      } else {
        throw Exception('음성 데이터가 생성되지 않았습니다');
      }
    } catch (e) {
      Logger.error('Failed to generate and play speech', e);
      state = PlaybackState.error;
      
      // Reset to idle after showing error
      await Future.delayed(const Duration(seconds: 2));
      state = PlaybackState.idle;
    }
  }

  Future<void> stop() async {
    try {
      await _repository.stopAudio();
      state = PlaybackState.stopped;
      
      // Reset to idle
      await Future.delayed(const Duration(milliseconds: 500));
      state = PlaybackState.idle;
    } catch (e) {
      Logger.error('Failed to stop audio', e);
      state = PlaybackState.error;
    }
  }

  void reset() {
    state = PlaybackState.idle;
    _lastResponse = null;
  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }
}

// TTS Playback Provider
final ttsPlaybackProvider =
    StateNotifierProvider<TTSPlaybackNotifier, PlaybackState>(
  (ref) {
    final repository = ref.watch(ttsRepositoryProvider);
    return TTSPlaybackNotifier(repository, ref);
  },
);

// TTS Status Message Provider
final ttsStatusMessageProvider = Provider<String>((ref) {
  final playbackState = ref.watch(ttsPlaybackProvider);
  final textInput = ref.watch(ttsTextProvider);
  
  switch (playbackState) {
    case PlaybackState.idle:
      if (textInput.isEmpty) {
        return '텍스트를 입력하고 재생 버튼을 누르세요';
      } else {
        return '재생 버튼을 눌러 음성을 들어보세요';
      }
    case PlaybackState.loading:
      return '음성 생성 중...';
    case PlaybackState.playing:
      return '재생 중...';
    case PlaybackState.stopped:
      return '중지됨';
    case PlaybackState.error:
      return '오류가 발생했습니다';
  }
});

// Character Count Provider
final characterCountProvider = Provider<String>((ref) {
  final text = ref.watch(ttsTextProvider);
  return '${text.length}/${AppConstants.maxTextLength}';
});