import 'dart:typed_data';
import '../../data/models/tts_request.dart';
import '../../data/models/tts_response.dart';

abstract class TTSRepository {
  Future<void> initializeTTS(String modelPath);
  Future<TTSResponse> generateSpeech(TTSRequest request);
  Future<void> playAudio(Uint8List audioData);
  Future<void> stopAudio();
  Future<bool> isModelLoaded();
  void dispose();
}