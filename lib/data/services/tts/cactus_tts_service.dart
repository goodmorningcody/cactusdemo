import 'dart:typed_data';
import 'dart:io';
import 'dart:math';
import 'package:cactus/cactus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../../core/utils/logger.dart';
import '../../../domain/services/tts_service_interface.dart';
import '../../models/tts_request.dart';
import '../../models/tts_response.dart';

/// Cactus TTS Service Implementation
/// Uses the Cactus framework to run OuteTTS model locally
class CactusTTSService implements TTSServiceInterface {
  CactusTTS? _model;
  bool _isInitialized = false;
  String? _modelPath;
  Map<String, dynamic> _voiceParameters = {};
  
  // OuteTTS specific model URL
  static const String _outeTTSModelUrl = 
    'https://huggingface.co/OuteAI/OuteTTS-0.2-500M-GGUF/resolve/main/OuteTTS-0.2-500M-Q4_K_M.gguf';
  
  @override
  Future<void> initialize(String modelPath) async {
    try {
      Logger.info('Initializing Cactus TTS with model: $modelPath');
      
      // Check if model file exists
      final modelFile = File(modelPath);
      if (!await modelFile.exists()) {
        Logger.warning('Model file not found at $modelPath, downloading...');
        modelPath = await _downloadModel();
      }
      
      // Initialize Cactus TTS model
      _model = await CactusTTS.init(
        modelUrl: 'file://$modelPath',
        contextSize: 4096, // Optimal for OuteTTS
        gpuLayers: Platform.isAndroid || Platform.isIOS ? 10 : 30,
        threads: Platform.numberOfProcessors,
        onProgress: (progress, message, isError) {
          Logger.info('TTS init progress: $message');
        },
      );
      
      _modelPath = modelPath;
      _isInitialized = true;
      
      Logger.success('Cactus TTS initialized successfully');
    } catch (e) {
      Logger.error('Failed to initialize Cactus TTS: $e');
      throw Exception('Failed to initialize TTS: $e');
    }
  }
  
  @override
  Future<TTSResponse> generateSpeech(TTSRequest request) async {
    if (!_isInitialized || _model == null) {
      throw Exception('TTS not initialized');
    }
    
    try {
      Logger.info('Generating speech for: ${request.text}');
      
      // Prepare the text for generation
      // Note: OuteTTS models may require specific formatting
      final formattedText = _formatTextForOuteTTS(request.text, request.language);
      
      // Generate audio using Cactus
      final startTime = DateTime.now();
      final result = await _model!.generate(
        formattedText,
        temperature: _voiceParameters['temperature'] as double? ?? 0.7,
        topP: _voiceParameters['topP'] as double? ?? 0.9,
        topK: _voiceParameters['topK'] as int? ?? 40,
        maxTokens: 2048,
      );
      final generationTime = DateTime.now().difference(startTime).inMilliseconds;
      
      // Convert generated text to audio bytes (mock for now)
      // Note: Actual audio generation depends on the model's capabilities
      final audioData = await _convertToAudio(result.text);
      
      Logger.success('Speech generated in ${generationTime}ms');
      
      // Create response
      return TTSResponse(
        audioData: audioData,
        format: 'wav',
        sampleRate: 16000, // OuteTTS default sample rate
        duration: _calculateDuration(audioData.length, 16000),
        metadata: {
          'model': 'OuteTTS-0.2-500M',
          'language': request.language,
          'text_length': request.text.length,
          'generation_time_ms': generationTime,
          'voice': _voiceParameters['voice'] ?? 'default',
        },
      );
    } catch (e) {
      Logger.error('Failed to generate speech: $e');
      throw Exception('Failed to generate speech: $e');
    }
  }
  
  @override
  Future<void> setVoiceParameters({
    double? speed,
    double? pitch,
    String? voice,
    String? language,
  }) async {
    _voiceParameters = {
      if (speed != null) 'speed': speed,
      if (pitch != null) 'pitch': pitch,
      if (voice != null) 'voice': voice,
      if (language != null) 'language': language,
    };
    
    Logger.info('Voice parameters updated: $_voiceParameters');
  }
  
  @override
  Future<void> stop() async {
    if (_model != null) {
      await _model!.stopCompletion();
      Logger.info('TTS generation stopped');
    }
  }
  
  @override
  bool get isInitialized => _isInitialized;
  
  @override
  bool get supportsAudio => _model != null;
  
  @override
  Map<String, dynamic> get modelInfo => {
    'name': 'OuteTTS-0.2-500M',
    'quantization': 'Q4_K_M',
    'context_size': 4096,
    'languages': ['en', 'ko', 'ja', 'zh'],
    'file_size': '350MB',
    'model_path': _modelPath,
    'is_initialized': _isInitialized,
  };
  
  @override
  void dispose() {
    _model?.dispose();
    _model = null;
    _isInitialized = false;
    _modelPath = null;
    Logger.info('Cactus TTS service disposed');
  }
  
  /// Format text for OuteTTS model
  String _formatTextForOuteTTS(String text, String language) {
    // OuteTTS may require specific formatting
    // This is a placeholder - adjust based on model requirements
    return text;
  }
  
  /// Convert generated tokens/text to audio bytes
  Future<Uint8List> _convertToAudio(String generatedText) async {
    // This is a placeholder for actual audio conversion
    // OuteTTS models generate audio tokens that need to be converted
    // For now, returning mock audio data
    Logger.warning('Audio conversion not fully implemented - returning mock data');
    
    // Generate simple sine wave as placeholder
    final sampleRate = 16000;
    final duration = 1000; // 1 second
    final samples = sampleRate * duration ~/ 1000;
    final audioData = Uint8List(samples * 2);
    
    for (int i = 0; i < samples; i++) {
      final value = (32767 * sin(2 * pi * 440 * i / sampleRate)).round();
      audioData[i * 2] = value & 0xFF;
      audioData[i * 2 + 1] = (value >> 8) & 0xFF;
    }
    
    return audioData;
  }
  
  /// Download the OuteTTS model from Hugging Face
  Future<String> _downloadModel() async {
    try {
      Logger.info('Downloading OuteTTS model from Hugging Face...');
      
      final appDir = await getApplicationDocumentsDirectory();
      final modelsDir = Directory(path.join(appDir.path, 'models'));
      
      if (!await modelsDir.exists()) {
        await modelsDir.create(recursive: true);
      }
      
      final modelPath = path.join(modelsDir.path, 'OuteTTS-0.2-500M-Q4_K_M.gguf');
      final modelFile = File(modelPath);
      
      // Check if already exists
      if (await modelFile.exists()) {
        Logger.info('Model already exists at: $modelPath');
        return modelPath;
      }
      
      // Download model using HTTP (Cactus will handle it during init)
      // For now, we'll let the model download service handle this
      throw Exception('Model not found. Please download it first.');
      
      Logger.success('Model downloaded successfully to: $modelPath');
      return modelPath;
    } catch (e) {
      Logger.error('Failed to download model: $e');
      throw Exception('Failed to download model: $e');
    }
  }
  
  /// Calculate audio duration from byte length and sample rate
  int _calculateDuration(int byteLength, int sampleRate) {
    // Assuming 16-bit audio (2 bytes per sample)
    final samples = byteLength ~/ 2;
    return (samples * 1000 ~/ sampleRate); // Duration in milliseconds
  }
}