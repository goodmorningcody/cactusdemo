import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/model_repository_impl.dart';
import '../../data/repositories/tts_repository_impl.dart';
import '../../domain/repositories/model_repository.dart';
import '../../domain/repositories/tts_repository.dart';
import 'service_providers.dart';

// Model Repository Provider
final modelRepositoryProvider = Provider<ModelRepository>((ref) {
  final downloadService = ref.watch(modelDownloadServiceProvider);
  final fileService = ref.watch(fileServiceProvider);
  final preferencesService = ref.watch(preferencesServiceProvider);
  
  return ModelRepositoryImpl(
    downloadService: downloadService,
    fileService: fileService,
    preferencesService: preferencesService,
  );
});

// TTS Repository Provider
final ttsRepositoryProvider = Provider<TTSRepository>((ref) {
  final ttsService = ref.watch(ttsServiceProvider);
  final audioPlayerService = ref.watch(audioPlayerServiceProvider);
  
  final repository = TTSRepositoryImpl(
    ttsService: ttsService,
    audioPlayerService: audioPlayerService,
  );
  
  ref.onDispose(() {
    repository.dispose();
  });
  
  return repository;
});