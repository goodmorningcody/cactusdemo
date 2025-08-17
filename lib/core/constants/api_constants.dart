class ApiConstants {
  // Model Download URLs
  static const String huggingFaceBaseUrl = 'https://huggingface.co';
  static const String modelRepoPath = '/OuteAI/OuteTTS-0.2-500M-GGUF/resolve/main/';
  
  // Model Files
  static const String modelFileFP16 = 'OuteTTS-0.2-500M-FP16.gguf';
  static const String modelFileQ4 = 'OuteTTS-0.2-500M-Q4_K_M.gguf';
  
  // Use quantized version for mobile efficiency
  static const String defaultModelFile = modelFileQ4;
  
  // Network Configuration
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 60);
  static const Duration sendTimeout = Duration(seconds: 30);
  
  // Retry Configuration
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);
  
  // Download Configuration
  static const int downloadChunkSize = 1024 * 1024; // 1MB chunks
  static const double minFreeSpaceGB = 3.0; // Minimum free space required
  
  static String get modelDownloadUrl => 
      '$huggingFaceBaseUrl$modelRepoPath$defaultModelFile';
}