import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/utils/logger.dart';

class FileService {
  Future<Directory> getModelDirectory() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final modelDir = Directory('${appDir.path}/${AppConstants.modelFolderName}');
      
      if (!await modelDir.exists()) {
        await modelDir.create(recursive: true);
        Logger.info('Created model directory: ${modelDir.path}');
      }
      
      return modelDir;
    } catch (e) {
      Logger.error('Failed to get model directory', e);
      throw StorageException(
        message: '모델 디렉토리를 생성할 수 없습니다',
        originalError: e,
      );
    }
  }

  Future<String> getModelPath(String fileName) async {
    final modelDir = await getModelDirectory();
    return '${modelDir.path}/$fileName';
  }

  Future<bool> fileExists(String path) async {
    try {
      final file = File(path);
      return await file.exists();
    } catch (e) {
      Logger.error('Failed to check file existence', e);
      return false;
    }
  }

  Future<void> deleteFile(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        Logger.info('Deleted file: $path');
      }
    } catch (e) {
      Logger.error('Failed to delete file', e);
      throw StorageException(
        message: '파일을 삭제할 수 없습니다',
        originalError: e,
      );
    }
  }

  Future<double> getAvailableSpace() async {
    try {
      if (Platform.isIOS) {
        final dir = await getApplicationDocumentsDirectory();
        final stat = await Process.run('df', ['-k', dir.path]);
        final lines = stat.stdout.toString().split('\n');
        if (lines.length > 1) {
          final parts = lines[1].split(RegExp(r'\s+'));
          if (parts.length > 3) {
            final availableKB = int.tryParse(parts[3]) ?? 0;
            return availableKB / (1024 * 1024); // Convert to GB
          }
        }
      } else if (Platform.isAndroid) {
        final dir = await getApplicationDocumentsDirectory();
        final stat = await dir.stat();
        // This is a simplified approach for Android
        // In production, you might want to use platform channels for more accurate info
        return 10.0; // Default to 10GB for now
      }
      return 0.0;
    } catch (e) {
      Logger.error('Failed to get available space', e);
      return 0.0;
    }
  }

  Future<bool> hasEnoughSpace(double requiredGB) async {
    final available = await getAvailableSpace();
    return available >= requiredGB;
  }

  Future<int> getFileSize(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        final stat = await file.stat();
        return stat.size;
      }
      return 0;
    } catch (e) {
      Logger.error('Failed to get file size', e);
      return 0;
    }
  }
}