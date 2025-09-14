import 'package:flutter/cupertino.dart';

class PasswordVisibilityProvider extends ChangeNotifier{
  bool _isPasswordVisible = false;

  bool get isPasswordVisible => _isPasswordVisible;

  void toggle(){
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }
}