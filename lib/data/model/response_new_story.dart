
import 'package:json_annotation/json_annotation.dart';

part 'response_new_story.g.dart';

@JsonSerializable()
class ResponseNewStory {
  final bool error;
  final String message;

  ResponseNewStory({required this.error, required this.message});

  factory ResponseNewStory.fromJson(Map<String, dynamic> json) => _$ResponseNewStoryFromJson(json);
}
