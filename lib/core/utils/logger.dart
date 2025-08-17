import 'package:flutter/foundation.dart';

class Logger {
  static void debug(String message, [dynamic data]) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      print('🔍 [$timestamp] DEBUG: $message');
      if (data != null) {
        print('   Data: $data');
      }
    }
  }

  static void info(String message, [dynamic data]) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      print('ℹ️ [$timestamp] INFO: $message');
      if (data != null) {
        print('   Data: $data');
      }
    }
  }

  static void warning(String message, [dynamic data]) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      print('⚠️ [$timestamp] WARNING: $message');
      if (data != null) {
        print('   Data: $data');
      }
    }
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      print('❌ [$timestamp] ERROR: $message');
      if (error != null) {
        print('   Error: $error');
      }
      if (stackTrace != null) {
        print('   StackTrace: $stackTrace');
      }
    }
  }

  static void success(String message, [dynamic data]) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      print('✅ [$timestamp] SUCCESS: $message');
      if (data != null) {
        print('   Data: $data');
      }
    }
  }
}