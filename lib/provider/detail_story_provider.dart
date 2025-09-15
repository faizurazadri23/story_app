import 'package:flutter/cupertino.dart';

import '../data/api/api_services.dart';
import '../static/story_detail_result_state.dart';

class DetailStoryProvider extends ChangeNotifier{
  final ApiServices _apiServices;

  DetailStoryProvider(this._apiServices);

  StoryDetailResultState _resultState = StoryDetailNoneState();

  StoryDetailResultState get resultState => _resultState;

  Future<void> fetchDetailStory(String id, String token) async {
    try{

      _resultState = StoryDetailLoadingState();
      notifyListeners();
      final response = await _apiServices.loadDetail(id, token);

      if(response.error){
        _resultState = StoryDetailErrorState(response.message);
        notifyListeners();
      }else{
        _resultState = StoryDetailLoadedState(response.story);
        notifyListeners();
      }
    }on Exception catch(e) {
      _resultState = StoryDetailErrorState(e.toString().replaceAll('Exception:', '').trim());
      notifyListeners();
    }
  }
}