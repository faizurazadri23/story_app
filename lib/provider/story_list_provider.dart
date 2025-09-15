import 'package:flutter/cupertino.dart';
import 'package:story_app/data/api/api_services.dart';
import 'package:story_app/static/story_list_result_state.dart';

class StoryListProvider extends ChangeNotifier {
  final ApiServices _apiServices;

  StoryListProvider(this._apiServices);

  StoryListResultState _resultState = StoryListNoneState();

  StoryListResultState get resultState => _resultState;

  Future<void> fetchStories(int page, int size, String token) async {
    try {
      _resultState = StoryListLoadingState();
      notifyListeners();
      final response = await _apiServices.loadAll(page, size, token);
      if (response.error) {
        _resultState = StoryListErrorState(response.message);
        notifyListeners();
      } else {
        _resultState = StoryListLoadedState(response.listStory);
        notifyListeners();
      }
    } on Exception catch (e) {
      _resultState = StoryListErrorState(e.toString().replaceAll('Exception:', '').trim());
      notifyListeners();
    }
  }
}
