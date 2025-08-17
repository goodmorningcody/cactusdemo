import 'package:json_annotation/json_annotation.dart';

part 'model_status.g.dart';

enum ModelState {
  notInstalled,
  downloading,
  installed,
  loading,
  ready,
  error,
}

@JsonSerializable()
class ModelStatus {
  final String modelId;
  final ModelState state;
  final String? modelPath;
  final DateTime? installedAt;
  final String? errorMessage;
  final bool isLoaded;
  final double? loadProgress;

  ModelStatus({
    required this.modelId,
    required this.state,
    this.modelPath,
    this.installedAt,
    this.errorMessage,
    this.isLoaded = false,
    this.loadProgress,
  });

  factory ModelStatus.notInstalled(String modelId) => ModelStatus(
        modelId: modelId,
        state: ModelState.notInstalled,
      );

  factory ModelStatus.installed({
    required String modelId,
    required String modelPath,
    required DateTime installedAt,
  }) =>
      ModelStatus(
        modelId: modelId,
        state: ModelState.installed,
        modelPath: modelPath,
        installedAt: installedAt,
      );

  factory ModelStatus.fromJson(Map<String, dynamic> json) =>
      _$ModelStatusFromJson(json);

  Map<String, dynamic> toJson() => _$ModelStatusToJson(this);

  bool get canUse => state == ModelState.ready && isLoaded;

  String get stateMessage {
    switch (state) {
      case ModelState.notInstalled:
        return '모델이 설치되지 않았습니다';
      case ModelState.downloading:
        return '모델을 다운로드 중입니다';
      case ModelState.installed:
        return '모델이 설치되었습니다';
      case ModelState.loading:
        return '모델을 로딩 중입니다';
      case ModelState.ready:
        return '모델을 사용할 준비가 되었습니다';
      case ModelState.error:
        return errorMessage ?? '오류가 발생했습니다';
    }
  }

  ModelStatus copyWith({
    String? modelId,
    ModelState? state,
    String? modelPath,
    DateTime? installedAt,
    String? errorMessage,
    bool? isLoaded,
    double? loadProgress,
  }) {
    return ModelStatus(
      modelId: modelId ?? this.modelId,
      state: state ?? this.state,
      modelPath: modelPath ?? this.modelPath,
      installedAt: installedAt ?? this.installedAt,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoaded: isLoaded ?? this.isLoaded,
      loadProgress: loadProgress ?? this.loadProgress,
    );
  }
}