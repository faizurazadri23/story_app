import 'package:flutter/material.dart';
import '../utils/service/shared_preference_service.dart';

class ThemeProvider extends ChangeNotifier {
  final SharedPreferenceService _preferenceService;
  ThemeMode _selectedThemeMode = ThemeMode.system;

  ThemeMode get selectedThemeMode => _selectedThemeMode;

  ThemeProvider(this._preferenceService) {
    _loadThemeMode();
  }

  void _loadThemeMode() async {
    _selectedThemeMode = _preferenceService.getThemeValue();
    notifyListeners();
  }

  setSelectedThemeMode(ThemeMode themeMode) {
    _selectedThemeMode = themeMode;
    notifyListeners();
  }
}
