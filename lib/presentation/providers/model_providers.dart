import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/download_progress.dart';
import '../../data/models/model_status.dart';
import '../../data/models/tts_model.dart';
import '../../core/utils/logger.dart';
import '../../domain/repositories/model_repository.dart';
import 'repository_providers.dart';
import 'service_providers.dart';

// Default TTS Model Provider
final defaultModelProvider = FutureProvider<TTSModel>((ref) async {
  final repository = ref.watch(modelRepositoryProvider);
  return await repository.getDefaultModel();
});

// Model Status State Notifier
class ModelStatusNotifier extends StateNotifier<AsyncValue<ModelStatus>> {
  final ModelRepository _repository;
  final String _modelId;

  ModelStatusNotifier(this._repository, this._modelId)
      : super(const AsyncValue.loading()) {
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    try {
      final status = await _repository.getModelStatus(_modelId);
      state = AsyncValue.data(status);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await _loadStatus();
  }

  Future<void> updateStatus(ModelStatus status) async {
    try {
      await _repository.saveModelStatus(status);
      state = AsyncValue.data(status);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// Model Status Provider
final modelStatusProvider = StateNotifierProvider.family<
    ModelStatusNotifier, AsyncValue<ModelStatus>, String>(
  (ref, modelId) {
    final repository = ref.watch(modelRepositoryProvider);
    return ModelStatusNotifier(repository, modelId);
  },
);

// Download Progress State Notifier
class DownloadProgressNotifier extends StateNotifier<DownloadProgress?> {
  final ModelRepository _repository;
  final Ref _ref;

  DownloadProgressNotifier(this._repository, this._ref) : super(null);

  Future<void> startDownload(TTSModel model) async {
    try {
      Logger.info('Starting download for model: ${model.id}');
      
      // Update model status to downloading
      final statusNotifier = _ref.read(modelStatusProvider(model.id).notifier);
      await statusNotifier.updateStatus(
        ModelStatus(
          modelId: model.id,
          state: ModelState.downloading,
        ),
      );

      // Start download and listen to progress
      await for (final progress in _repository.downloadModel(model)) {
        state = progress;
        
        // If download completed, update model status
        if (progress.status == DownloadStatus.completed) {
          final modelPath = await _ref
              .read(fileServiceProvider)
              .getModelPath('outetts_model.gguf');
          
          await statusNotifier.updateStatus(
            ModelStatus.installed(
              modelId: model.id,
              modelPath: modelPath,
              installedAt: DateTime.now(),
            ),
          );
          
          Logger.success('Model download completed');
        } else if (progress.status == DownloadStatus.failed) {
          await statusNotifier.updateStatus(
            ModelStatus(
              modelId: model.id,
              state: ModelState.error,
              errorMessage: progress.errorMessage,
            ),
          );
          
          Logger.error('Model download failed: ${progress.errorMessage}');
        }
      }
    } catch (e) {
      Logger.error('Download error', e);
      state = DownloadProgress(
        modelId: model.id,
        status: DownloadStatus.failed,
        errorMessage: e.toString(),
      );
    }
  }

  void cancelDownload() {
    _repository.cancelDownload();
    state = state?.copyWith(status: DownloadStatus.cancelled);
  }

  void reset() {
    state = null;
  }
}

// Download Progress Provider
final downloadProgressProvider =
    StateNotifierProvider<DownloadProgressNotifier, DownloadProgress?>(
  (ref) {
    final repository = ref.watch(modelRepositoryProvider);
    return DownloadProgressNotifier(repository, ref);
  },
);

// Model Installation Check Provider
final isModelInstalledProvider = FutureProvider.family<bool, String>(
  (ref, modelId) async {
    final repository = ref.watch(modelRepositoryProvider);
    return await repository.isModelInstalled(modelId);
  },
);