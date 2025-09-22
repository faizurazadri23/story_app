import 'package:flutter/cupertino.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../data/api/api_services.dart';
import '../data/model/my_latlng.dart';
import '../static/story_detail_result_state.dart';
import '../utils/helper.dart';

class DetailStoryProvider extends ChangeNotifier{
  final ApiServices _apiServices;

  DetailStoryProvider(this._apiServices);

  StoryDetailResultState _resultState = StoryDetailNoneState();

  StoryDetailResultState get resultState => _resultState;
  
  bool _isClickMarker = false;
  
  bool get isClickMarker => _isClickMarker;
  
  String _address="";
  
  String get address => _address;

  ScreenCoordinate? _popupScreenPosition;
  ScreenCoordinate? get popupScreenPosition => _popupScreenPosition;

  set isClickMarker(bool value) {
    _isClickMarker = value;
    notifyListeners();
  }

  set popupScreenPosition(ScreenCoordinate? value) {
    _popupScreenPosition = value;
    notifyListeners();
  }

  void setAddress(MyLtLng location) async {
    var result = await Helper.getLocationName(location.latitude, location.longitude);
    var placeMark = result[0];
    _address = "${placeMark.street} ${placeMark.subLocality} ${placeMark.locality} ${placeMark.subAdministrativeArea} ${placeMark.administrativeArea} ${placeMark.postalCode}";
    notifyListeners();
  }

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