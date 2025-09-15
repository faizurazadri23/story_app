import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/camera_provider.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _StateCamera();
}

class _StateCamera extends State<CameraPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cameraProvider = context.watch<CameraProvider>();
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Take Picture'),
          actions: [
            IconButton(
              onPressed: () => cameraProvider.switchCamera(),
              icon: Icon(Icons.cameraswitch),
            ),
          ],
        ),
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              cameraProvider.isInitialized && cameraProvider.controller != null
                  ? CameraPreview(cameraProvider.controller!)
                  : const Center(child: CircularProgressIndicator()),
              Align(
                alignment: const Alignment(0.0, 0.95),
                child: FloatingActionButton(
                  onPressed: () async {
                    pop(value) => context.pop(value);
                    final image = await cameraProvider.takePicture();
                    pop(image);
                  },
                  heroTag: "take-picture",
                  tooltip: "Ambil Gambar",
                  child: const Icon(Icons.camera_alt),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
