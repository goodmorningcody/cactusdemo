import '../../core/constants/api_constants.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/logger.dart';
import '../../domain/repositories/model_repository.dart';
import '../models/download_progress.dart';
import '../models/model_status.dart';
import '../models/tts_model.dart';
import '../services/api/model_download_service.dart';
import '../services/local/file_service.dart';
import '../services/local/preferences_service.dart';

class ModelRepositoryImpl implements ModelRepository {
  final ModelDownloadService _downloadService;
  final FileService _fileService;
  final PreferencesService _preferencesService;

  ModelRepositoryImpl({
    required ModelDownloadService downloadService,
    required FileService fileService,
    required PreferencesService preferencesService,
  })  : _downloadService = downloadService,
        _fileService = fileService,
        _preferencesService = preferencesService;

  @override
  Future<TTSModel> getDefaultModel() async {
    return TTSModel(
      id: 'outetts-v0.2-500m',
      name: AppConstants.modelName,
      version: 'v0.2',
      format: AppConstants.modelFormat,
      sizeInGB: 2.0,
      downloadUrl: ApiConstants.modelDownloadUrl,
      supportedLanguages: ['ko', 'en', 'ja', 'zh'],
    );
  }

  @override
  Future<ModelStatus> getModelStatus(String modelId) async {
    // Try to get from preferences first
    final cached = _preferencesService.getModelStatus(modelId);
    if (cached != null) {
      return cached;
    }

    // Check if model file exists
    final modelPath = await _fileService.getModelPath(AppConstants.modelFileName);
    final exists = await _fileService.fileExists(modelPath);
    
    if (exists) {
      final installDate = _preferencesService.getInstallDate();
      return ModelStatus.installed(
        modelId: modelId,
        modelPath: modelPath,
        installedAt: installDate ?? DateTime.now(),
      );
    }
    
    return ModelStatus.notInstalled(modelId);
  }

  @override
  Future<void> saveModelStatus(ModelStatus status) async {
    await _preferencesService.saveModelStatus(status);
    
    if (status.state == ModelState.installed && status.modelPath != null) {
      await _preferencesService.setModelInstalled(true);
      await _preferencesService.setModelPath(status.modelPath!);
      
      if (status.installedAt != null) {
        await _preferencesService.setInstallDate(status.installedAt!);
      }
    } else if (status.state == ModelState.notInstalled) {
      await _preferencesService.clearModelData();
    }
    
    Logger.info('Model status saved: ${status.state}');
  }

  @override
  Stream<DownloadProgress> downloadModel(TTSModel model) {
    return _downloadService.downloadModel(
      modelId: model.id,
      downloadUrl: model.downloadUrl,
      fileName: AppConstants.modelFileName,
    );
  }

  @override
  Future<void> deleteModel(String modelId) async {
    try {
      final modelPath = await _fileService.getModelPath(AppConstants.modelFileName);
      await _fileService.deleteFile(modelPath);
      await _preferencesService.clearModelData();
      
      await saveModelStatus(ModelStatus.notInstalled(modelId));
      
      Logger.success('Model deleted successfully');
    } catch (e) {
      Logger.error('Failed to delete model', e);
      rethrow;
    }
  }

  @override
  Future<bool> isModelInstalled(String modelId) async {
    final status = await getModelStatus(modelId);
    return status.state == ModelState.installed || 
           status.state == ModelState.ready;
  }

  @override
  void cancelDownload() {
    _downloadService.cancelDownload();
  }
}