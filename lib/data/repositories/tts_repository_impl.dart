import 'dart:typed_data';
import '../../core/utils/logger.dart';
import '../../domain/repositories/tts_repository.dart';
import '../../domain/services/tts_service_interface.dart';
import '../models/tts_request.dart';
import '../models/tts_response.dart';
import '../services/tts/audio_player_service.dart';

class TTSRepositoryImpl implements TTSRepository {
  final TTSServiceInterface _ttsService;
  final AudioPlayerService _audioPlayerService;

  TTSRepositoryImpl({
    required TTSServiceInterface ttsService,
    required AudioPlayerService audioPlayerService,
  })  : _ttsService = ttsService,
        _audioPlayerService = audioPlayerService;

  @override
  Future<void> initializeTTS(String modelPath) async {
    try {
      await _ttsService.initialize(modelPath);
      Logger.success('TTS initialized with model: $modelPath');
    } catch (e) {
      Logger.error('Failed to initialize TTS', e);
      rethrow;
    }
  }

  @override
  Future<TTSResponse> generateSpeech(TTSRequest request) async {
    try {
      if (!await isModelLoaded()) {
        throw Exception('모델이 로드되지 않았습니다');
      }

      final response = await _ttsService.generateSpeech(request);
      Logger.success('Speech generated for text: ${request.text}');
      
      return response;
    } catch (e) {
      Logger.error('Failed to generate speech', e);
      rethrow;
    }
  }

  @override
  Future<void> playAudio(Uint8List audioData) async {
    try {
      await _audioPlayerService.playAudio(audioData);
    } catch (e) {
      Logger.error('Failed to play audio', e);
      rethrow;
    }
  }

  @override
  Future<void> stopAudio() async {
    try {
      await _audioPlayerService.stop();
    } catch (e) {
      Logger.error('Failed to stop audio', e);
      rethrow;
    }
  }

  @override
  Future<bool> isModelLoaded() async {
    return _ttsService.isInitialized;
  }

  @override
  void dispose() {
    _ttsService.dispose();
    _audioPlayerService.dispose();
    Logger.info('TTSRepository disposed');
  }
}