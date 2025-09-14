import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class Helper{
  static Future<List<Placemark>> getLocationName(double lat, double lon) async {
    List<Placemark> placeMarks = await placemarkFromCoordinates(lat, lon);
    return placeMarks;
  }

  static Future<void> getCurrentLocation(
      Function(Position) callbackCurrentLocation) async {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    Position position =
    await Geolocator.getCurrentPosition(locationSettings: locationSettings);

    callbackCurrentLocation(position);
  }
}