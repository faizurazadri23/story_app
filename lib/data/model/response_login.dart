
import 'package:json_annotation/json_annotation.dart';

import 'login_result.dart';

part 'response_login.g.dart';

@JsonSerializable()
class ResponseLogin {
  final bool error;
  final String message;
  final LoginResult loginResult;

  ResponseLogin({
    required this.error,
    required this.message,
    required this.loginResult,
  });

  factory ResponseLogin.fromJson(Map<String, dynamic> json) {
    return ResponseLogin(
      error: json['error'],
      message: json['message'],
      loginResult: LoginResult.fromJson(json['loginResult']),
    );
  }
}
