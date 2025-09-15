import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/form_story_provider.dart';
import 'package:story_app/static/story_post_result_state.dart';

import '../../provider/auth_provider.dart';

class FormStoryPage extends StatefulWidget {
  const FormStoryPage({super.key});

  @override
  State<FormStoryPage> createState() => _StateFormStory();
}

class _StateFormStory extends State<FormStoryPage> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _coordinatedController = TextEditingController();
  late Position? _currentPosition;

  @override
  void initState() {
    _currentPosition = null;
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<FormStoryProvider>().getCurrentLocation();
        _currentPosition = context.read<FormStoryProvider>().currentPosition;
        _coordinatedController.text =
            '${_currentPosition?.latitude}, ${_currentPosition?.longitude}';
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Form Story')),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _descriptionController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your description';
                        }
                        return null;
                      },
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Description',
                        hintText: 'Enter your description',
                      ),
                    ),
                    SizedBox(height: 25),
                    TextFormField(
                      controller: _coordinatedController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your location';
                        }
                        return null;
                      },
                      maxLines: 1,
                      keyboardType: TextInputType.none,
                      readOnly: true,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Coordinated',
                        hintText: 'Sync your location',
                        suffixIcon: GestureDetector(
                          onTap: () {
                            _currentPosition = context
                                .read<FormStoryProvider>()
                                .currentPosition;
                            _coordinatedController.text =
                                '${_currentPosition?.latitude}, ${_currentPosition?.longitude}';
                          },
                          child: Icon(Icons.location_searching_rounded),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Upload Image',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    InkWell(
                      onTap: () async {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Upload Image'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.camera_alt),
                                    title: Text('Camera'),
                                    onTap: () async {
                                      final provider = context
                                          .read<FormStoryProvider>();
                                      final cameras = await availableCameras();
                                      if (!context.mounted) return;
                                      final XFile? resultImageFile =
                                          await context.push(
                                            '/camera',
                                            extra: cameras,
                                          );

                                      if (resultImageFile != null) {
                                        provider.setImageFile(resultImageFile);
                                        provider.setImagePath(
                                          resultImageFile.path,
                                        );
                                      }
                                      if (!context.mounted) return;
                                      context.pop();
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.image),
                                    title: Text('Gallery'),
                                    onTap: () async {
                                      await _onGalleryView();
                                      if (!context.mounted) return;
                                      context.pop();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      splashColor: Colors.transparent,
                      splashFactory: NoSplash.splashFactory,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[200],
                        ),
                        width: MediaQuery.sizeOf(context).width,
                        child:
                            context.watch<FormStoryProvider>().imagePath == null
                            ? Icon(Icons.image, color: Colors.grey, size: 100)
                            : _showImage(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () async {
                  final provider = context.read<FormStoryProvider>();

                  final desc = _descriptionController.text.toString();
                  final filePath = provider.imagePath;
                  final lat = provider.currentPosition.latitude.toString();
                  final lon = provider.currentPosition.longitude.toString();

                  if (desc.isEmpty || filePath == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Lengkapi deskripsi & gambar'),
                      ),
                    );
                    return;
                  }
                  var data = context.read<AuthProvider>().loginResult;
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) =>
                        const Center(child: CircularProgressIndicator()),
                  );
                  await provider.newStory(
                    filePath,
                    desc,
                    data!.token,
                    lat,
                    lon,
                  );

                  if (context.mounted) {
                    context.pop();
                  }

                  final state = provider.resultState;

                  if (state is StoryPostLoadedState) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.responseNewStory.message)),
                      );
                      context.go("/story", extra: true);
                    }
                  } else if (state is StoryPostErrorState) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.error)));
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Simpan', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showImage() {
    final imagePath = context.read<FormStoryProvider>().imagePath;
    return Image.file(File(imagePath.toString()), fit: BoxFit.cover);
  }

  Future<void> _onGalleryView() async {
    final provider = context.read<FormStoryProvider>();
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      provider.setImageFile(image);
      provider.setImagePath(image.path);
    }
  }
}
