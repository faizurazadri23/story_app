import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../data/api/api_services.dart';
import '../static/story_post_result_state.dart';

class FormStoryProvider extends ChangeNotifier {
  String? imagePath;
  XFile? imageFile;
  late Position _currentPosition;
  final ApiServices _apiServices;

  FormStoryProvider(this._apiServices);

  Position get currentPosition => _currentPosition;

  StoryPostResultState _resultState = StoryPostNoneState();

  StoryPostResultState get resultState => _resultState;

  void setImagePath(String? value) {
    imagePath = value;
    notifyListeners();
  }

  void setImageFile(XFile? value) {
    imageFile = value;
    notifyListeners();
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location service are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Location permission are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    _currentPosition = await Geolocator.getCurrentPosition();
    notifyListeners();
  }

  Future<void> newStory(String filePath,
      String description,
      String token,
      String latitude,
      String longitude,) async {
    try {
      _resultState = StoryPostLoadingState();
      notifyListeners();
      final response = await _apiServices.newStory(
          filePath, description, token, latitude, longitude);
      if (response.error) {
        _resultState = StoryPostErrorState(response.message);
        notifyListeners();
      } else {
        _resultState = StoryPostLoadedState(response);
        notifyListeners();
      }
    } on Exception catch (e) {
      _resultState = StoryPostErrorState(e.toString().replaceAll('Exception:', '').trim());
      notifyListeners();
    }
  }
}