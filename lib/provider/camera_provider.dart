import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

class CameraProvider extends ChangeNotifier{
  final List<CameraDescription> cameras;
  CameraController? controller;
  bool _isInitialized = false;
  bool _isBackCameraSelected = true;

  bool get isInitialized => _isInitialized;

  CameraProvider(this.cameras){
    if(cameras.isNotEmpty){
      onNewCameraSelected(cameras.first);
    }
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;
    final cameraController = CameraController(cameraDescription, ResolutionPreset.medium);

    await previousCameraController?.dispose();

    try{
      await cameraController.initialize();
      controller = cameraController;
      _isInitialized = controller!.value.isInitialized;
      notifyListeners();
    }on CameraException catch(e){
      if(kDebugMode){
        print('Error initializing camera :$e');
      }
    }
  }

  Future<void> switchCamera()async{
    if(cameras.length<=1)return;
    _isInitialized = false;
    notifyListeners();
    await onNewCameraSelected(cameras[_isBackCameraSelected?1:0]);
    _isBackCameraSelected = !_isBackCameraSelected;
    notifyListeners();
  }

  Future<XFile?> takePicture()async{
    if(controller==null || !controller!.value.isInitialized) return null;
    return await controller!.takePicture();
  }

  @override
  void dispose(){
    controller?.dispose();
    super.dispose();
  }
}