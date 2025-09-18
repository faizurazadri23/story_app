import 'package:json_annotation/json_annotation.dart';
import 'package:story_app/data/model/story.dart';

part 'response_detail_story.g.dart';

@JsonSerializable()
class ResponseDetailStory {
  bool error;
  String message;
  Story story;

  ResponseDetailStory({
    required this.error,
    required this.message,
    required this.story,
  });


  factory ResponseDetailStory.fromJson(Map<String, dynamic> json) => _$ResponseDetailStoryFromJson(json);

}
