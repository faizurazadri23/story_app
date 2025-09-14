class LatLngValidator {
  static double fixLatitude(double lat) {
    if (lat > 90) return 90;
    if (lat < -90) return -90;
    return lat;
  }

  static double fixLongitude(double lng) {
    if (lng > 180) return 180;
    if (lng < -180) return -180;
    return lng;
  }

  static (double, double) validate(double lat, double lng) {
    return (fixLatitude(lat), fixLongitude(lng));
  }
}
