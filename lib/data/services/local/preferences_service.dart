import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/logger.dart';
import '../../models/model_status.dart';

class PreferencesService {
  late final SharedPreferences _prefs;
  
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    Logger.info('PreferencesService initialized');
  }

  Future<bool> setModelInstalled(bool installed) async {
    return await _prefs.setBool(AppConstants.prefKeyModelInstalled, installed);
  }

  bool getModelInstalled() {
    return _prefs.getBool(AppConstants.prefKeyModelInstalled) ?? false;
  }

  Future<bool> setModelPath(String path) async {
    return await _prefs.setString(AppConstants.prefKeyModelPath, path);
  }

  String? getModelPath() {
    return _prefs.getString(AppConstants.prefKeyModelPath);
  }

  Future<bool> setInstallDate(DateTime date) async {
    return await _prefs.setString(
      AppConstants.prefKeyInstallDate,
      date.toIso8601String(),
    );
  }

  DateTime? getInstallDate() {
    final dateStr = _prefs.getString(AppConstants.prefKeyInstallDate);
    if (dateStr != null) {
      try {
        return DateTime.parse(dateStr);
      } catch (e) {
        Logger.error('Failed to parse install date', e);
      }
    }
    return null;
  }

  Future<bool> saveModelStatus(ModelStatus status) async {
    try {
      final json = jsonEncode(status.toJson());
      return await _prefs.setString('model_status_${status.modelId}', json);
    } catch (e) {
      Logger.error('Failed to save model status', e);
      return false;
    }
  }

  ModelStatus? getModelStatus(String modelId) {
    try {
      final json = _prefs.getString('model_status_$modelId');
      if (json != null) {
        return ModelStatus.fromJson(jsonDecode(json));
      }
    } catch (e) {
      Logger.error('Failed to get model status', e);
    }
    return null;
  }

  Future<bool> clearModelData() async {
    bool success = true;
    success &= await _prefs.remove(AppConstants.prefKeyModelInstalled);
    success &= await _prefs.remove(AppConstants.prefKeyModelPath);
    success &= await _prefs.remove(AppConstants.prefKeyInstallDate);
    
    // Clear all model status entries
    final keys = _prefs.getKeys().where((key) => key.startsWith('model_status_'));
    for (final key in keys) {
      success &= await _prefs.remove(key);
    }
    
    return success;
  }

  Future<void> clear() async {
    await _prefs.clear();
    Logger.info('All preferences cleared');
  }
}