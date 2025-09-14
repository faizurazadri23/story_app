import 'package:story_app/data/model/story.dart';

class ResponseStory {
  bool error;
  String message;
  List<Story> listStory;

  ResponseStory({
    required this.error,
    required this.message,
    required this.listStory,
  });

  factory ResponseStory.fromJson(Map<String, dynamic> json) => ResponseStory(
    error: json["error"],
    message: json["message"],
    listStory: List<Story>.from(
      json["listStory"].map((x) => Story.fromJson(x)),
    ),
  );
}


