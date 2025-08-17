// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tts_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TTSModel _$TTSModelFromJson(Map<String, dynamic> json) => TTSModel(
      id: json['id'] as String,
      name: json['name'] as String,
      version: json['version'] as String,
      format: json['format'] as String,
      sizeInGB: (json['sizeInGB'] as num).toDouble(),
      downloadUrl: json['downloadUrl'] as String,
      supportedLanguages: (json['supportedLanguages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      installedAt: json['installedAt'] == null
          ? null
          : DateTime.parse(json['installedAt'] as String),
      localPath: json['localPath'] as String?,
    );

Map<String, dynamic> _$TTSModelToJson(TTSModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'version': instance.version,
      'format': instance.format,
      'sizeInGB': instance.sizeInGB,
      'downloadUrl': instance.downloadUrl,
      'supportedLanguages': instance.supportedLanguages,
      'installedAt': instance.installedAt?.toIso8601String(),
      'localPath': instance.localPath,
    };
