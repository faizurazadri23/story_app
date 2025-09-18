import 'package:flutter/cupertino.dart';
import 'package:story_app/data/api/api_services.dart';
import 'package:story_app/static/story_list_result_state.dart';

import '../data/model/story.dart';

class StoryListProvider extends ChangeNotifier {
  final ApiServices _apiServices;

  StoryListProvider(this._apiServices);

  StoryListResultState _resultState = StoryListNoneState();

  StoryListResultState get resultState => _resultState;
  final List<Story> _storyList = [];

  List<Story> get storyList => _storyList;

  int? pageItems = 1;
  int sizeItems = 10;

  Future<void> fetchStories(String token) async {
    try {
      if (pageItems == 1) {
        _resultState = StoryListLoadingState();
        notifyListeners();
      }
      final response = await _apiServices.loadAll(pageItems!, sizeItems, token);
      if (response.error) {
        _resultState = StoryListErrorState(response.message);
      } else {
        _storyList.addAll(response.listStory);
        _resultState = StoryListLoadedState(_storyList);
        if (response.listStory.isEmpty) {
          pageItems = null;
        } else {
          pageItems = pageItems! + 1;
        }
      }

      notifyListeners();
    } on Exception catch (e) {
      _resultState = StoryListErrorState(
        e.toString().replaceAll('Exception:', '').trim(),
      );
      notifyListeners();
    }
  }
}
