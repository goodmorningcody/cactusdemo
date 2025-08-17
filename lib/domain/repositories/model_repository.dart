import '../../data/models/download_progress.dart';
import '../../data/models/model_status.dart';
import '../../data/models/tts_model.dart';

abstract class ModelRepository {
  Future<TTSModel> getDefaultModel();
  Future<ModelStatus> getModelStatus(String modelId);
  Future<void> saveModelStatus(ModelStatus status);
  Stream<DownloadProgress> downloadModel(TTSModel model);
  Future<void> deleteModel(String modelId);
  Future<bool> isModelInstalled(String modelId);
  void cancelDownload();
}