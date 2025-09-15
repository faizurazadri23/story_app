import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/detail_story_provider.dart';
import 'package:story_app/provider/theme_provider.dart';
import 'package:story_app/ui/component/response_error.dart';
import 'package:story_app/utils/helper.dart';
import 'package:story_app/utils/service/remote_config_service.dart';

import '../../static/story_detail_result_state.dart';

class DetailStoryPage extends StatefulWidget {
  final String id;

  const DetailStoryPage({super.key, required this.id});

  @override
  State<DetailStoryPage> createState() => _StateDetailStory();
}

class _StateDetailStory extends State<DetailStoryPage> {
  late MapboxMap? mapboxMap;
  late PointAnnotationManager _pointAnnotationManager;

  @override
  void initState() {
    MapboxOptions.setAccessToken(RemoteConfigService().mapboxAccessToken);
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<DetailStoryProvider>().fetchDetailStory(
          widget.id,
          context.read<AuthProvider>().loginResult!.token,
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
  }

  Future<void> _addMarker(double latitude, double longitude) async {
    _pointAnnotationManager = await mapboxMap!.annotations
        .createPointAnnotationManager();

    final ByteData bytes = await rootBundle.load('assets/images/marker.png');
    final Uint8List list = bytes.buffer.asUint8List();

    await _pointAnnotationManager.create(
      PointAnnotationOptions(
        geometry: Point(coordinates: Position(longitude, latitude)),
        image: list,
        iconSize: 5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Story')),
      body: Consumer<DetailStoryProvider>(
        builder: (context, value, child) {
          return switch (value.resultState) {
            StoryDetailLoadingState() => Center(
              child: CircularProgressIndicator(),
            ),
            StoryDetailLoadedState(story: var story) => Stack(
              children: [
                Positioned.fill(
                  child: MapWidget(
                    styleUri: context.read<ThemeProvider>().selectedThemeMode==ThemeMode.dark ? MapboxStyles.DARK :MapboxStyles.MAPBOX_STREETS,
                    onMapCreated: (mapboxMap) {
                      _onMapCreated(mapboxMap);
                      if (story.lon != null && story.lat != null) {
                        _addMarker(story.lat!, story.lon!);
                        mapboxMap.flyTo(
                          CameraOptions(
                            zoom: 12,
                            center: Point(
                              coordinates: Position(story.lon!, story.lat!),
                            ),
                          ),
                          MapAnimationOptions(duration: 2000, startDelay: 0),
                        );
                      } else {
                        Helper.getCurrentLocation((currentLocation) {
                          mapboxMap.flyTo(
                            CameraOptions(
                              zoom: 12,
                              center: Point(
                                coordinates: Position(
                                  currentLocation.longitude,
                                  currentLocation.latitude,
                                ),
                              ),
                            ),
                            MapAnimationOptions(duration: 2000, startDelay: 0),
                          );
                        });
                      }
                    },
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(10),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.network(story.photoUrl, width: 120),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                story.name,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                story.description,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            StoryDetailErrorState(error: var error) => Center(
              child: ResponseError(message: error),
            ),
            _ => Container(),
          };
        },
      ),
    );
  }
}
