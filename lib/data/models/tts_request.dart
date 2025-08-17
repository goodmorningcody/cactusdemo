import 'package:json_annotation/json_annotation.dart';

part 'tts_request.g.dart';

@JsonSerializable()
class TTSRequest {
  final String text;
  final String language;
  final double speed;
  final double pitch;
  final String? voiceId;
  final Map<String, dynamic>? additionalParams;

  TTSRequest({
    required this.text,
    this.language = 'ko',
    this.speed = 1.0,
    this.pitch = 1.0,
    this.voiceId,
    this.additionalParams,
  });

  factory TTSRequest.fromJson(Map<String, dynamic> json) =>
      _$TTSRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TTSRequestToJson(this);

  TTSRequest copyWith({
    String? text,
    String? language,
    double? speed,
    double? pitch,
    String? voiceId,
    Map<String, dynamic>? additionalParams,
  }) {
    return TTSRequest(
      text: text ?? this.text,
      language: language ?? this.language,
      speed: speed ?? this.speed,
      pitch: pitch ?? this.pitch,
      voiceId: voiceId ?? this.voiceId,
      additionalParams: additionalParams ?? this.additionalParams,
    );
  }
}