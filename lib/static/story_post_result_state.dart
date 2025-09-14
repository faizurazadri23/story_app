import 'package:story_app/data/model/response_new_story.dart';

sealed class StoryPostResultState {}

class StoryPostNoneState extends StoryPostResultState {}

class StoryPostLoadingState extends StoryPostResultState {}

class StoryPostErrorState extends StoryPostResultState {
  final String error;

  StoryPostErrorState(this.error);
}

class StoryPostLoadedState extends StoryPostResultState {
  final ResponseNewStory responseNewStory;

  StoryPostLoadedState(this.responseNewStory);
}
