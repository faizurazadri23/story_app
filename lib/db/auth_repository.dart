import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/data/model/response_login.dart';

class AuthRepository {
  final String userKey = "user";

  Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 2));
    final value = preferences.getString(userKey);
    return value != null && value.isNotEmpty;
  }

  Future<bool> logout() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 2));
    return preferences.setString(userKey, "");
  }

  Future<bool> saveLogin(LoginResult loginResult) async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 2));
    return preferences.setString(userKey, jsonEncode(loginResult.toJson()));
  }

  Future<LoginResult?> getUser() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 2));
    final userJson = preferences.getString(userKey) ?? "";
    LoginResult? user;
    try {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      user = LoginResult.fromJson(userMap);
    } catch (e) {
      user = null;
    }
    return user;
  }
}
