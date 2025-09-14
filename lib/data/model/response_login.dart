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

class LoginResult {
  final String userId;
  final String name;
  final String token;

  LoginResult({required this.userId, required this.name, required this.token});

  factory LoginResult.fromJson(Map<String, dynamic> json) {
    return LoginResult(
      userId: json['userId'],
      name: json['name'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'userId': userId, 'name': name, 'token': token};
  }
}
