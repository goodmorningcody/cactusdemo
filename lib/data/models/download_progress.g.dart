// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DownloadProgress _$DownloadProgressFromJson(Map<String, dynamic> json) =>
    DownloadProgress(
      modelId: json['modelId'] as String,
      status: $enumDecode(_$DownloadStatusEnumMap, json['status']),
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      downloadedBytes: (json['downloadedBytes'] as num?)?.toInt() ?? 0,
      totalBytes: (json['totalBytes'] as num?)?.toInt() ?? 0,
      downloadSpeed: (json['downloadSpeed'] as num?)?.toDouble() ?? 0.0,
      estimatedTimeRemaining: json['estimatedTimeRemaining'] == null
          ? null
          : Duration(
              microseconds: (json['estimatedTimeRemaining'] as num).toInt()),
      errorMessage: json['errorMessage'] as String?,
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$DownloadProgressToJson(DownloadProgress instance) =>
    <String, dynamic>{
      'modelId': instance.modelId,
      'status': _$DownloadStatusEnumMap[instance.status]!,
      'progress': instance.progress,
      'downloadedBytes': instance.downloadedBytes,
      'totalBytes': instance.totalBytes,
      'downloadSpeed': instance.downloadSpeed,
      'estimatedTimeRemaining': instance.estimatedTimeRemaining?.inMicroseconds,
      'errorMessage': instance.errorMessage,
      'startedAt': instance.startedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
    };

const _$DownloadStatusEnumMap = {
  DownloadStatus.idle: 'idle',
  DownloadStatus.downloading: 'downloading',
  DownloadStatus.paused: 'paused',
  DownloadStatus.completed: 'completed',
  DownloadStatus.failed: 'failed',
  DownloadStatus.cancelled: 'cancelled',
};
