import 'package:json_annotation/json_annotation.dart';
import 'package:story_app/data/model/story.dart';

part 'response_story.g.dart';

@JsonSerializable()
class ResponseStory {
  bool error;
  String message;
  List<Story> listStory;

  ResponseStory({
    required this.error,
    required this.message,
    required this.listStory,
  });

  factory ResponseStory.fromJson(Map<String, dynamic> json) => _$ResponseStoryFromJson(json);
}


