import 'dart:typed_data';
import '../../data/models/tts_request.dart';
import '../../data/models/tts_response.dart';

/// TTS Service Interface
/// Defines the contract for TTS implementations
abstract class TTSServiceInterface {
  /// Initialize the TTS service with a model
  Future<void> initialize(String modelPath);
  
  /// Generate speech from text
  Future<TTSResponse> generateSpeech(TTSRequest request);
  
  /// Check if the service is initialized
  bool get isInitialized;
  
  /// Check if audio generation is supported
  bool get supportsAudio;
  
  /// Get model information
  Map<String, dynamic> get modelInfo;
  
  /// Set voice parameters
  Future<void> setVoiceParameters({
    double? speed,
    double? pitch,
    String? voice,
    String? language,
  });
  
  /// Stop any ongoing generation
  Future<void> stop();
  
  /// Dispose of resources
  void dispose();
}