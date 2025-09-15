import 'package:flutter/cupertino.dart';
import 'package:story_app/data/api/api_services.dart';
import 'package:story_app/static/story_list_result_state.dart';

import '../data/model/story.dart';

class StoryListProvider extends ChangeNotifier {
  final ApiServices _apiServices;

  StoryListProvider(this._apiServices);

  StoryListResultState _resultState = StoryListNoneState();

  StoryListResultState get resultState => _resultState;
  List<Story> _storyList = [];

  List<Story> get storyList => _storyList;

  int _currentPage = 1;
  int get currentPage =>  _currentPage;

  bool _isLastPage = false;
  bool get isLastPage => _isLastPage;

  Future<void> fetchStories(int page, int size, String token, {bool refresh = false}) async {
    try {
      if(refresh || page ==1){
        _storyList = [];
        _isLastPage = false;
        _currentPage = 1;
      }
      _resultState = StoryListLoadingState();
      notifyListeners();
      final response = await _apiServices.loadAll(page, size, token);
      if (response.error) {
        _resultState = StoryListErrorState(response.message);
        notifyListeners();
      } else {
        if(response.listStory.isEmpty){
         _isLastPage = true;
        }else{
          if(page==1 || refresh){
            _storyList = response.listStory;
          }else{
            _storyList.addAll(response.listStory);
          }
          _currentPage = page;
        }
        _resultState = StoryListLoadedState(response.listStory);
      }
      notifyListeners();
    } on Exception catch (e) {
      _resultState = StoryListErrorState(e.toString().replaceAll('Exception:', '').trim());
      notifyListeners();
    }
  }
}
