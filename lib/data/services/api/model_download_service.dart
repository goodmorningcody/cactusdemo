import 'dart:async';
import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/utils/logger.dart';
import '../../models/download_progress.dart';
import '../local/file_service.dart';

class ModelDownloadService {
  final Dio _dio;
  final FileService _fileService;
  CancelToken? _cancelToken;
  StreamController<DownloadProgress>? _progressController;
  Timer? _speedCalculatorTimer;
  
  int _lastDownloadedBytes = 0;
  DateTime _lastSpeedCheck = DateTime.now();

  ModelDownloadService({
    required Dio dio,
    required FileService fileService,
  })  : _dio = dio,
        _fileService = fileService;

  Stream<DownloadProgress> downloadModel({
    required String modelId,
    required String downloadUrl,
    required String fileName,
  }) async* {
    _progressController = StreamController<DownloadProgress>.broadcast();
    _cancelToken = CancelToken();
    
    try {
      // Check available space
      final hasSpace = await _fileService.hasEnoughSpace(ApiConstants.minFreeSpaceGB);
      if (!hasSpace) {
        throw StorageException(
          message: '저장 공간이 부족합니다. 최소 ${ApiConstants.minFreeSpaceGB}GB가 필요합니다.',
        );
      }

      final savePath = await _fileService.getModelPath(fileName);
      
      // Check if file already exists
      if (await _fileService.fileExists(savePath)) {
        Logger.info('Model file already exists at: $savePath');
        yield DownloadProgress(
          modelId: modelId,
          status: DownloadStatus.completed,
          progress: 1.0,
        );
        return;
      }

      // Start download
      yield DownloadProgress(
        modelId: modelId,
        status: DownloadStatus.downloading,
        progress: 0.0,
        startedAt: DateTime.now(),
      );

      // Setup speed calculator
      _startSpeedCalculator(modelId);

      await _dio.download(
        downloadUrl,
        savePath,
        cancelToken: _cancelToken,
        deleteOnError: true,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = received / total;
            final downloadProgress = _calculateProgress(
              modelId: modelId,
              downloadedBytes: received,
              totalBytes: total,
              progress: progress,
            );
            
            _progressController?.add(downloadProgress);
          }
        },
        options: Options(
          receiveTimeout: const Duration(minutes: 30),
          headers: {
            'Accept-Encoding': 'gzip, deflate, br',
          },
        ),
      );

      // Verify file exists after download
      if (!await _fileService.fileExists(savePath)) {
        throw DownloadException(
          message: '다운로드가 완료되었지만 파일을 찾을 수 없습니다.',
        );
      }

      // Download completed
      yield DownloadProgress(
        modelId: modelId,
        status: DownloadStatus.completed,
        progress: 1.0,
        completedAt: DateTime.now(),
      );

      Logger.success('Model downloaded successfully: $savePath');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        yield DownloadProgress(
          modelId: modelId,
          status: DownloadStatus.cancelled,
          errorMessage: '다운로드가 취소되었습니다',
        );
      } else {
        yield DownloadProgress(
          modelId: modelId,
          status: DownloadStatus.failed,
          errorMessage: _getErrorMessage(e),
        );
      }
      Logger.error('Download failed', e);
    } catch (e) {
      yield DownloadProgress(
        modelId: modelId,
        status: DownloadStatus.failed,
        errorMessage: e.toString(),
      );
      Logger.error('Download failed', e);
    } finally {
      _stopSpeedCalculator();
      await _progressController?.close();
    }
  }

  void cancelDownload() {
    _cancelToken?.cancel('사용자가 다운로드를 취소했습니다');
    Logger.info('Download cancelled by user');
  }

  void pauseDownload() {
    // Note: Dio doesn't support true pause/resume
    // This is a simplified implementation
    cancelDownload();
  }

  DownloadProgress _calculateProgress({
    required String modelId,
    required int downloadedBytes,
    required int totalBytes,
    required double progress,
  }) {
    final now = DateTime.now();
    final timeDiff = now.difference(_lastSpeedCheck).inMilliseconds;
    
    double speed = 0;
    if (timeDiff > 0) {
      final bytesDiff = downloadedBytes - _lastDownloadedBytes;
      speed = (bytesDiff / timeDiff) * 1000; // bytes per second
    }
    
    Duration? estimatedTime;
    if (speed > 0) {
      final remainingBytes = totalBytes - downloadedBytes;
      final remainingSeconds = remainingBytes / speed;
      estimatedTime = Duration(seconds: remainingSeconds.toInt());
    }
    
    _lastDownloadedBytes = downloadedBytes;
    _lastSpeedCheck = now;
    
    return DownloadProgress(
      modelId: modelId,
      status: DownloadStatus.downloading,
      progress: progress,
      downloadedBytes: downloadedBytes,
      totalBytes: totalBytes,
      downloadSpeed: speed,
      estimatedTimeRemaining: estimatedTime,
    );
  }

  void _startSpeedCalculator(String modelId) {
    _speedCalculatorTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        // Update speed calculation periodically
      },
    );
  }

  void _stopSpeedCalculator() {
    _speedCalculatorTimer?.cancel();
    _speedCalculatorTimer = null;
  }

  String _getErrorMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return '연결 시간이 초과되었습니다';
      case DioExceptionType.receiveTimeout:
        return '다운로드 시간이 초과되었습니다';
      case DioExceptionType.connectionError:
        return '네트워크 연결을 확인해주세요';
      default:
        return error.message ?? '다운로드 중 오류가 발생했습니다';
    }
  }

  void dispose() {
    _cancelToken?.cancel();
    _stopSpeedCalculator();
    _progressController?.close();
  }
}