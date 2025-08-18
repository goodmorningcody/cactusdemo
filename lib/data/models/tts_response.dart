import 'dart:typed_data';
import 'package:json_annotation/json_annotation.dart';

part 'tts_response.g.dart';

@JsonSerializable()
class TTSResponse {
  final String? audioUrl;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Uint8List? audioData;
  final String format;
  final int sampleRate;
  final int duration; // in milliseconds
  final Map<String, dynamic>? metadata;

  TTSResponse({
    this.audioUrl,
    this.audioData,
    required this.format,
    required this.sampleRate,
    required this.duration,
    this.metadata,
  });

  factory TTSResponse.fromJson(Map<String, dynamic> json) =>
      _$TTSResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TTSResponseToJson(this);

  bool get hasAudioData => audioData != null && audioData!.isNotEmpty;
  
  bool get hasAudioUrl => audioUrl != null && audioUrl!.isNotEmpty;

  String get durationFormatted {
    final seconds = duration ~/ 1000;
    final milliseconds = duration % 1000;
    return '$seconds.${milliseconds.toString().padLeft(3, '0')}초';
  }

  TTSResponse copyWith({
    String? audioUrl,
    Uint8List? audioData,
    String? format,
    int? sampleRate,
    int? duration,
    Map<String, dynamic>? metadata,
  }) {
    return TTSResponse(
      audioUrl: audioUrl ?? this.audioUrl,
      audioData: audioData ?? this.audioData,
      format: format ?? this.format,
      sampleRate: sampleRate ?? this.sampleRate,
      duration: duration ?? this.duration,
      metadata: metadata ?? this.metadata,
    );
  }
}