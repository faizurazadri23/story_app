class ResponseRegister {
  final bool error;
  final String message;

  ResponseRegister({required this.error, required this.message});

  factory ResponseRegister.fromJson(Map<String, dynamic> json) {
    return ResponseRegister(
      error: json['error'],
      message: json['message'],
    );
  }

}
