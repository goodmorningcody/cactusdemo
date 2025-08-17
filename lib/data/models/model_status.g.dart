// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModelStatus _$ModelStatusFromJson(Map<String, dynamic> json) => ModelStatus(
      modelId: json['modelId'] as String,
      state: $enumDecode(_$ModelStateEnumMap, json['state']),
      modelPath: json['modelPath'] as String?,
      installedAt: json['installedAt'] == null
          ? null
          : DateTime.parse(json['installedAt'] as String),
      errorMessage: json['errorMessage'] as String?,
      isLoaded: json['isLoaded'] as bool? ?? false,
      loadProgress: (json['loadProgress'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ModelStatusToJson(ModelStatus instance) =>
    <String, dynamic>{
      'modelId': instance.modelId,
      'state': _$ModelStateEnumMap[instance.state]!,
      'modelPath': instance.modelPath,
      'installedAt': instance.installedAt?.toIso8601String(),
      'errorMessage': instance.errorMessage,
      'isLoaded': instance.isLoaded,
      'loadProgress': instance.loadProgress,
    };

const _$ModelStateEnumMap = {
  ModelState.notInstalled: 'notInstalled',
  ModelState.downloading: 'downloading',
  ModelState.installed: 'installed',
  ModelState.loading: 'loading',
  ModelState.ready: 'ready',
  ModelState.error: 'error',
};
