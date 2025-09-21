import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../data/api/api_services.dart';
import '../data/model/my_latlng.dart';
import '../static/story_post_result_state.dart';
import '../utils/helper.dart';

class FormStoryProvider extends ChangeNotifier {
  String? imagePath;
  XFile? imageFile;
  Placemark? placemark;

  MyLtLng? _currentPosition;
  final ApiServices _apiServices;

  FormStoryProvider(this._apiServices);

  MyLtLng? get currentPosition => _currentPosition;

  MyLtLng? _selectedLocation;
  MyLtLng? get selectedLocation => _selectedLocation;

  StoryPostResultState _resultState = StoryPostNoneState();

  StoryPostResultState get resultState => _resultState;

  final TextEditingController _addressController = TextEditingController();
  TextEditingController get addressController => _addressController;

  void setImagePath(String? value) {
    imagePath = value;
    notifyListeners();
  }

  void setImageFile(XFile? value) {
    imageFile = value;
    notifyListeners();
  }

  void setSelectedLocation(MyLtLng? value) {
    _selectedLocation = value;
    setAddress(value!);
    notifyListeners();
  }

  void setAddress(MyLtLng location) async {
    var result = await Helper.getLocationName(location.latitude, location.longitude);
    placemark = result[0];
    _addressController.text = "${placemark?.street} ${placemark?.subLocality} ${placemark?.locality} ${placemark?.subAdministrativeArea} ${placemark?.administrativeArea} ${placemark?.postalCode}";
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

    var myLocation = await Geolocator.getCurrentPosition();
    _currentPosition = MyLtLng(latitude: myLocation.latitude, longitude: myLocation.longitude);
    notifyListeners();
  }

  Future<void> newStory(
      String filePath,
      String description,
      String token,
      String latitude,
      String longitude,
      ) async {
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
