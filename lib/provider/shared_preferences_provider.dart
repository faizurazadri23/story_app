import 'package:flutter/material.dart';
import 'package:story_app/utils/service/shared_preference_service.dart';

class SharedPreferencesProvider extends ChangeNotifier {
  final SharedPreferenceService _service;

  SharedPreferencesProvider(this._service);

  String _message = "";

  String get message => _message;

  Future<void> saveThemeMode(ThemeMode value) async {
    try {
      await _service.saveThemeMode(value: value);
      _message = "Success";
    } catch (e) {
      _message = "Failed to save theme mode";
    }
    notifyListeners();
  }
}
