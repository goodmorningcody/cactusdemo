import 'package:json_annotation/json_annotation.dart';

part 'tts_model.g.dart';

@JsonSerializable()
class TTSModel {
  final String id;
  final String name;
  final String version;
  final String format;
  final double sizeInGB;
  final String downloadUrl;
  final List<String> supportedLanguages;
  final DateTime? installedAt;
  final String? localPath;

  TTSModel({
    required this.id,
    required this.name,
    required this.version,
    required this.format,
    required this.sizeInGB,
    required this.downloadUrl,
    required this.supportedLanguages,
    this.installedAt,
    this.localPath,
  });

  factory TTSModel.fromJson(Map<String, dynamic> json) => 
      _$TTSModelFromJson(json);

  Map<String, dynamic> toJson() => _$TTSModelToJson(this);

  bool get isInstalled => localPath != null && installedAt != null;

  String get displaySize => '${sizeInGB.toStringAsFixed(1)} GB';

  TTSModel copyWith({
    String? id,
    String? name,
    String? version,
    String? format,
    double? sizeInGB,
    String? downloadUrl,
    List<String>? supportedLanguages,
    DateTime? installedAt,
    String? localPath,
  }) {
    return TTSModel(
      id: id ?? this.id,
      name: name ?? this.name,
      version: version ?? this.version,
      format: format ?? this.format,
      sizeInGB: sizeInGB ?? this.sizeInGB,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      supportedLanguages: supportedLanguages ?? this.supportedLanguages,
      installedAt: installedAt ?? this.installedAt,
      localPath: localPath ?? this.localPath,
    );
  }
}