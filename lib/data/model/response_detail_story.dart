import 'package:story_app/data/model/story.dart';

class ResponseDetailStory {
  bool error;
  String message;
  Story story;

  ResponseDetailStory({
    required this.error,
    required this.message,
    required this.story,
  });

  factory ResponseDetailStory.fromJson(Map<String, dynamic> json) =>
      ResponseDetailStory(
        error: json["error"],
        message: json["message"],
        story: Story.fromJson(json["story"]),
      );
}
