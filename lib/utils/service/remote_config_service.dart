import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService{
  static final RemoteConfigService _instance = RemoteConfigService._internal();
  factory RemoteConfigService() => _instance;

  late FirebaseRemoteConfig _remoteConfig;

  RemoteConfigService._internal();

  Future<void> init()async{
    _remoteConfig = FirebaseRemoteConfig.instance;

    await _remoteConfig.fetchAndActivate();
  }

  String get mapboxAccessToken => _remoteConfig.getString('mapbox');
}