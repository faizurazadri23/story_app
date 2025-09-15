import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/detail_story_provider.dart';

import '../../static/story_detail_result_state.dart';

class DetailStoryPage extends StatefulWidget {
  final String id;

  const DetailStoryPage({super.key, required this.id});

  @override
  State<DetailStoryPage> createState() => _StateDetailStory();
}

class _StateDetailStory extends State<DetailStoryPage> {
  late MapboxMap? mapboxMap;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
  }
  Future<void> _addMarker(double latitude, double longitude)async{

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
                    onMapCreated: (mapboxMap) {
                      _onMapCreated(mapboxMap);
                    },
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Card(
                    color: Colors.white,
                    child: Padding(padding: EdgeInsets.all(10)),
                  ),
                ),
              ],
            ),
            StoryDetailErrorState(error: var error) => Center(
              child: Text(error),
            ),
            _ => Container(),
          };
        },
      ),
    );
  }
}
