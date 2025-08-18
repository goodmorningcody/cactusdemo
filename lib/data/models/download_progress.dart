import 'package:json_annotation/json_annotation.dart';

part 'download_progress.g.dart';

enum DownloadStatus {
  idle,
  downloading,
  paused,
  completed,
  failed,
  cancelled,
}

@JsonSerializable()
class DownloadProgress {
  final String modelId;
  final DownloadStatus status;
  final double progress; // 0.0 to 1.0
  final int downloadedBytes;
  final int totalBytes;
  final double downloadSpeed; // bytes per second
  final Duration? estimatedTimeRemaining;
  final String? errorMessage;
  final DateTime? startedAt;
  final DateTime? completedAt;

  DownloadProgress({
    required this.modelId,
    required this.status,
    this.progress = 0.0,
    this.downloadedBytes = 0,
    this.totalBytes = 0,
    this.downloadSpeed = 0.0,
    this.estimatedTimeRemaining,
    this.errorMessage,
    this.startedAt,
    this.completedAt,
  });

  factory DownloadProgress.initial(String modelId) => DownloadProgress(
        modelId: modelId,
        status: DownloadStatus.idle,
      );

  factory DownloadProgress.fromJson(Map<String, dynamic> json) =>
      _$DownloadProgressFromJson(json);

  Map<String, dynamic> toJson() => _$DownloadProgressToJson(this);

  String get progressPercentage => '${(progress * 100).toStringAsFixed(1)}%';

  String get downloadedSize => _formatBytes(downloadedBytes);

  String get totalSize => _formatBytes(totalBytes);

  String get speedFormatted => '${_formatBytes(downloadSpeed.toInt())}/s';

  String get remainingTimeFormatted {
    if (estimatedTimeRemaining == null) return '계산 중...';
    
    final minutes = estimatedTimeRemaining!.inMinutes;
    final seconds = estimatedTimeRemaining!.inSeconds % 60;
    
    if (minutes > 0) {
      return '약 $minutes분 $seconds초 남음';
    } else {
      return '약 $seconds초 남음';
    }
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    int i = 0;
    double value = bytes.toDouble();
    
    while (value >= 1024 && i < suffixes.length - 1) {
      value /= 1024;
      i++;
    }
    
    return '${value.toStringAsFixed(1)} ${suffixes[i]}';
  }

  DownloadProgress copyWith({
    String? modelId,
    DownloadStatus? status,
    double? progress,
    int? downloadedBytes,
    int? totalBytes,
    double? downloadSpeed,
    Duration? estimatedTimeRemaining,
    String? errorMessage,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return DownloadProgress(
      modelId: modelId ?? this.modelId,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      downloadedBytes: downloadedBytes ?? this.downloadedBytes,
      totalBytes: totalBytes ?? this.totalBytes,
      downloadSpeed: downloadSpeed ?? this.downloadSpeed,
      estimatedTimeRemaining: estimatedTimeRemaining ?? this.estimatedTimeRemaining,
      errorMessage: errorMessage ?? this.errorMessage,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}