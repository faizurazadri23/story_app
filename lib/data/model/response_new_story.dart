class ResponseNewStory {
  final bool error;
  final String message;

  ResponseNewStory({required this.error, required this.message});

  factory ResponseNewStory.fromJson(Map<String, dynamic> json){
    return ResponseNewStory(
      error: json['error'],
      message: json['message'],
    );
  }
}
