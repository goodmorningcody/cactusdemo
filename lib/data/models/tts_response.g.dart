// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tts_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TTSResponse _$TTSResponseFromJson(Map<String, dynamic> json) => TTSResponse(
      audioUrl: json['audioUrl'] as String?,
      format: json['format'] as String,
      sampleRate: (json['sampleRate'] as num).toInt(),
      duration: (json['duration'] as num).toInt(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$TTSResponseToJson(TTSResponse instance) =>
    <String, dynamic>{
      'audioUrl': instance.audioUrl,
      'format': instance.format,
      'sampleRate': instance.sampleRate,
      'duration': instance.duration,
      'metadata': instance.metadata,
    };
