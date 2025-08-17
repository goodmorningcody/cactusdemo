import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/api/dio_client.dart';
import '../../data/services/api/model_download_service.dart';
import '../../data/services/local/file_service.dart';
import '../../data/services/local/preferences_service.dart';
import '../../data/services/tts/audio_player_service.dart';
import '../../data/services/tts/mock_tts_service.dart';

// Dio Client Provider
final dioProvider = Provider<Dio>((ref) {
  return DioClient().dio;
});

// File Service Provider
final fileServiceProvider = Provider<FileService>((ref) {
  return FileService();
});

// Preferences Service Provider
final preferencesServiceProvider = Provider<PreferencesService>((ref) {
  final service = PreferencesService();
  // Note: init() needs to be called before using the service
  return service;
});

// Model Download Service Provider
final modelDownloadServiceProvider = Provider<ModelDownloadService>((ref) {
  final dio = ref.watch(dioProvider);
  final fileService = ref.watch(fileServiceProvider);
  
  return ModelDownloadService(
    dio: dio,
    fileService: fileService,
  );
});

// Audio Player Service Provider
final audioPlayerServiceProvider = Provider<AudioPlayerService>((ref) {
  final service = AudioPlayerService();
  
  ref.onDispose(() {
    service.dispose();
  });
  
  return service;
});

// Mock TTS Service Provider
final mockTTSServiceProvider = Provider<MockTTSService>((ref) {
  final service = MockTTSService();
  
  ref.onDispose(() {
    service.dispose();
  });
  
  return service;
});