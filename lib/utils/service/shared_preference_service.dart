import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  final SharedPreferences _preferences;

  SharedPreferenceService(this._preferences);

  static const String keyTheme = "STORYTHEME";

  Future<void> saveThemeMode({required ThemeMode value}) async {
    try {
      await _preferences.setString(keyTheme, value.toString().split('.').last);
    } catch (e) {
      throw Exception('Shared preference error');
    }
  }

  ThemeMode getThemeValue() {
    String? themeString = _preferences.getString(keyTheme);

    switch (themeString) {
      case "dark":
        return ThemeMode.dark;

      case "light":
        return ThemeMode.light;

      default:
        return ThemeMode.system;
    }
  }
}
