import 'package:shared_preferences/shared_preferences.dart';

class GameSettings {
  static const String _soundVolumeKey = 'sound_volume';
  static const String _musicVolumeKey = 'music_volume';
  static const String _vibrationEnabledKey = 'vibration_enabled';
  static const String _screenShakeEnabledKey = 'screen_shake_enabled';
  static const String _difficultyKey = 'difficulty';

  static Future<double> getSoundVolume() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_soundVolumeKey) ?? 1.0;
  }

  static Future<double> getMusicVolume() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_musicVolumeKey) ?? 1.0;
  }

  static Future<bool> isVibrationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_vibrationEnabledKey) ?? true;
  }

  static Future<bool> isScreenShakeEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_screenShakeEnabledKey) ?? true;
  }

  static Future<String> getDifficulty() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_difficultyKey) ?? 'Normal';
  }

  static double getDifficultyMultiplier(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return 0.7;
      case 'Normal':
        return 1.0;
      case 'Hard':
        return 1.5;
      case 'Expert':
        return 2.0;
      default:
        return 1.0;
    }
  }
}

