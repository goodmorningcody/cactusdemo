// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tts_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TTSRequest _$TTSRequestFromJson(Map<String, dynamic> json) => TTSRequest(
      text: json['text'] as String,
      language: json['language'] as String? ?? 'ko',
      speed: (json['speed'] as num?)?.toDouble() ?? 1.0,
      pitch: (json['pitch'] as num?)?.toDouble() ?? 1.0,
      voiceId: json['voiceId'] as String?,
      additionalParams: json['additionalParams'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$TTSRequestToJson(TTSRequest instance) =>
    <String, dynamic>{
      'text': instance.text,
      'language': instance.language,
      'speed': instance.speed,
      'pitch': instance.pitch,
      'voiceId': instance.voiceId,
      'additionalParams': instance.additionalParams,
    };
