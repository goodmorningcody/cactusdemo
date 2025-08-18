import 'dart:typed_data';
import 'dart:math';
import '../../../core/utils/logger.dart';
import '../../models/tts_request.dart';
import '../../models/tts_response.dart';

// Mock TTS Service for development
// This will be replaced with actual Cactus TTS implementation
class MockTTSService {
  bool _isInitialized = false;

  Future<void> initialize(String modelPath) async {
    Logger.info('Initializing Mock TTS with model: $modelPath');
    
    // Simulate initialization delay
    await Future.delayed(const Duration(seconds: 2));
    
    _isInitialized = true;
    
    Logger.success('Mock TTS initialized successfully');
  }

  Future<TTSResponse> generateSpeech(TTSRequest request) async {
    if (!_isInitialized) {
      throw Exception('TTS not initialized');
    }

    Logger.info('Generating speech for: ${request.text}');
    
    // Simulate processing time based on text length
    final processingTime = (request.text.length * 20).clamp(500, 5000);
    await Future.delayed(Duration(milliseconds: processingTime));
    
    // Generate mock audio data
    const sampleRate = 16000;
    final duration = request.text.length * 100; // ms per character
    final samples = (sampleRate * duration / 1000).round();
    
    // Create a simple sine wave as mock audio
    final audioData = Uint8List(samples * 2); // 16-bit audio
    for (int i = 0; i < samples; i++) {
      final value = (32767 * 
          sin(2 * pi * 440 * i / sampleRate) * // 440Hz tone
          (1 - i / samples) // Fade out
      ).round();
      
      // Convert to 16-bit little-endian
      audioData[i * 2] = value & 0xFF;
      audioData[i * 2 + 1] = (value >> 8) & 0xFF;
    }
    
    Logger.success('Speech generated successfully');
    
    return TTSResponse(
      audioData: audioData,
      format: 'wav',
      sampleRate: sampleRate,
      duration: duration,
      metadata: {
        'model': 'mock',
        'language': request.language,
        'text_length': request.text.length,
      },
    );
  }

  bool get isInitialized => _isInitialized;

  void dispose() {
    _isInitialized = false;
    Logger.info('Mock TTS service disposed');
  }
}