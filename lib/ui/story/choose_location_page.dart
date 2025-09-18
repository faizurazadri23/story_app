import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/model/my_latlng.dart';
import '../../provider/form_story_provider.dart';
import '../../utils/service/remote_config_service.dart';

class ChooseLocationPage extends StatefulWidget {
  const ChooseLocationPage({super.key});

  @override
  State<ChooseLocationPage> createState() => _StateChooseLocation();
}

class _StateChooseLocation extends State<ChooseLocationPage> {
  late MapboxMap? mapboxMap;
  late PointAnnotationManager _pointAnnotationManager;

  @override
  void initState() {
    mapboxMap = null;
    MapboxOptions.setAccessToken(RemoteConfigService().mapboxAccessToken);
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<FormStoryProvider>().getCurrentLocation();
      }
    });
  }

  void _onMapCreated(MapboxMap mapboxMap) async {
    _pointAnnotationManager =
    await mapboxMap.annotations.createPointAnnotationManager();
    mapboxMap.location.updateSettings(LocationComponentSettings(enabled: true,showAccuracyRing: true,pulsingEnabled: true));
    this.mapboxMap = mapboxMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Choose Location')),
      body: Consumer<FormStoryProvider>(builder: (context, value, child) {
        return Stack(
          children: [
            Positioned.fill(
              child: MapWidget(
                onMapCreated: _onMapCreated,
                styleUri: MapboxStyles.MAPBOX_STREETS,
                cameraOptions: CameraOptions(
                  center: Point(coordinates: Position(value.currentPosition!.longitude, value.currentPosition!.latitude)),
                  zoom: 15,
                ),
                onTapListener: (context)async {
                  mapboxMap!.annotations
                      .removeAnnotationManagerById(_pointAnnotationManager.id);

                  _pointAnnotationManager = await mapboxMap!.annotations
                      .createPointAnnotationManager();

                  mapboxMap!.setCamera(CameraOptions(
                      center: Point(coordinates: Position(double.parse(context.point.coordinates.lng.toString()), double.parse(context.point.coordinates.lat.toString()))),
                      zoom: 15));

                  final ByteData bytes = await rootBundle.load('assets/images/marker.png');
                  final Uint8List list = bytes.buffer.asUint8List();

                  await _pointAnnotationManager.create(
                    PointAnnotationOptions(
                      geometry: Point(coordinates: Position(double.parse(context.point.coordinates.lng.toString()), double.parse(context.point.coordinates.lat.toString()))),
                      image: list,
                      iconSize: 5,
                    ),
                  );

                  setLocation(double.parse(context.point.coordinates.lat.toString()), double.parse(context.point.coordinates.lng.toString()));
                },
              ),
            ),

            Positioned(
              bottom: 10,
              right: 10,
              left: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 value.placemark==null ? SizedBox.shrink() : Text("${value.placemark?.street} ${value.placemark?.subLocality} ${value.placemark?.locality} ${value.placemark?.subAdministrativeArea} ${value.placemark?.administrativeArea} ${value.placemark?.postalCode}",style: Theme.of(context).textTheme.bodySmall,),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: ElevatedButton(
                      onPressed: value.selectedLocation==null ? null :   () {
                        context.go("/story/form", extra: true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Pick Location',style: TextStyle(color: Colors.white),),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },),
    );
  }

  void setLocation(double lat, double lng) {
    context.read<FormStoryProvider>().setSelectedLocation(MyLtLng(latitude: lat, longitude: lng));
  }
}
