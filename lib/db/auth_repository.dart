import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/data/api/api_services.dart';
import 'package:story_app/data/model/response_login.dart';
import 'package:story_app/data/model/response_register.dart';

import '../data/model/user.dart';

class AuthRepository {
  final String stateKey = "state";
  final String userKey = "user";
  final ApiServices apiServices;

  AuthRepository(this.apiServices);

  Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 2));
    return preferences.getString(userKey) !=null;
  }

  Future<bool> logout() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 2));
    return preferences.setBool(stateKey, false);
  }

  Future<bool> saveLogin(LoginResult loginResult) async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 2));
    return preferences.setString(userKey, jsonEncode(loginResult.toJson()));
  }

  Future<bool> deleteUser() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 2));
    return preferences.setString(userKey, "");
  }

  Future<User?> getUser() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 2));
    final userJson = preferences.getString(userKey) ?? "";
    User? user;
    try {
      user = User.fromJson(userJson);
    } catch (e) {
      user = null;
    }
    return user;
  }

  Future<ResponseRegister> register(
    String name,
    String email,
    String password,
  ) async {
    return apiServices.register(name, email, password);
  }

  Future<ResponseLogin> login(String email, String password
      )async{
    return apiServices.login(email, password);
  }
}
