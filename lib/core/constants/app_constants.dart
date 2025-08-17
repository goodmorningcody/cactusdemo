class AppConstants {
  static const String appName = 'Cactus TTS Demo';
  
  // Text Input
  static const int maxTextLength = 500;
  static const String textInputHint = '음성으로 변환할 텍스트를 입력하세요';
  
  // Model Info
  static const String modelName = 'OuteTTS v0.2 - 500M';
  static const String modelSize = '약 2GB';
  static const String modelFormat = 'GGUF';
  static const String framework = 'Cactus TTS 엔진';
  
  // Storage
  static const String modelFolderName = 'tts_models';
  static const String modelFileName = 'outetts_model.gguf';
  
  // Preferences Keys
  static const String prefKeyModelInstalled = 'model_installed';
  static const String prefKeyModelPath = 'model_path';
  static const String prefKeyInstallDate = 'install_date';
  
  // UI
  static const double iconSize = 64.0;
  static const double buttonHeight = 48.0;
  static const double borderRadius = 12.0;
  static const double padding = 16.0;
  
  // Animation
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration snackBarDuration = Duration(seconds: 3);
}