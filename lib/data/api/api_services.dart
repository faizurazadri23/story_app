import 'dart:convert';

import 'package:story_app/data/model/response_login.dart';
import 'package:story_app/data/model/response_register.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static const String _baseUrl = "https://story-api.dicoding.dev/v1";

  Future<ResponseRegister> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/register"),
        body: {'name': name, 'email': email, 'password': password},
      );
      return ResponseRegister.fromJson(jsonDecode(response.body));
    } catch (e) {
      return ResponseRegister(error: true, message: "Terjadi kesalahan: $e");
    }
  }

  Future<ResponseLogin> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/login"),
        body: {'email': email, 'password': password},
      );

      return ResponseLogin.fromJson(jsonDecode(response.body));
    } catch (e) {
      return ResponseLogin(error: true, message: "Terjadi kesalahan: $e");
    }
  }
}
