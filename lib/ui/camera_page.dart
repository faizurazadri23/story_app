import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraPage({super.key, required this.cameras});

  @override
  State<CameraPage> createState() => _StateCamera();
}

class _StateCamera extends State<CameraPage> with WidgetsBindingObserver {
  bool _isCameraInitialized = false;
  bool _isBackCameraSelected = true;
  CameraController? controller;

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;
    final cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
    );

    await previousCameraController?.dispose();
    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      if (kDebugMode) {
        print('Error initializing camera : $e');
      }
    }

    if (mounted) {
      setState(() {
        controller = cameraController;
        _isCameraInitialized = controller!.value.isInitialized;
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    onNewCameraSelected(widget.cameras.first);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Take Picture'),
          actions: [
            IconButton(
              onPressed: () => _onCameraSwitch(),
              icon: Icon(Icons.cameraswitch),
            ),
          ],
        ),
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              _isCameraInitialized
                  ? CameraPreview(controller!)
                  : const Center(child: CircularProgressIndicator()),
              Align(
                alignment: const Alignment(0.0, 0.95),
                child: _actionWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionWidget() {
    return FloatingActionButton(
      onPressed: () async{
        final navigator = Navigator.of(context);
        final image = await controller?.takePicture();
        navigator.pop(image);
      },
      heroTag: "take-picture",
      tooltip: "Ambil Gambar",
      child: const Icon(Icons.camera_alt),
    );
  }

  void _onCameraSwitch() {
    if(widget.cameras.length==1) return;
    setState(() {
      _isCameraInitialized = false;
    });
    onNewCameraSelected(widget.cameras[_isBackCameraSelected ? 1 : 0]);
    setState(() {
      _isBackCameraSelected = !_isBackCameraSelected;
    });
  }
}
