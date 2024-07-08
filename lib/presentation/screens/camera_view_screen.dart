import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gallery_app_test/database/gallery_database.dart';
import 'package:gallery_app_test/entities/photo_entity.dart';

import 'package:gallery_app_test/presentation/provider/gallery_provider.dart';
import 'package:gallery_app_test/presentation/screens/gallery_screen.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class CameraViewScreen extends StatefulWidget {
  const CameraViewScreen({super.key});

  @override
  State<CameraViewScreen> createState() => _CameraViewScreenState();
}

class _CameraViewScreenState extends State<CameraViewScreen> {
  //не смог додуматься как вынести в отдельную модель првоайдера
  List<CameraDescription> cameras = [];
  CameraController? cameraController;

  @override
  void initState() {
    _setupCameraController();
    super.initState();
  }

//Без этой штуки приложение очень сильно кстати лагает, пол дня не мог додуматься диспозить контроллер и приложение лагало послпе 3 фоток
  @override
  void dispose() {
    cameraController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GalleryProvider galleryProvider = context.read<GalleryProvider>();
    return Scaffold(
      body: _buildUI(galleryProvider),
    );
  }

  Widget _buildUI(GalleryProvider galleryProvider) {
    if (cameraController == null ||
        cameraController?.value.isInitialized == false) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: 100,
              child: CameraPreview(cameraController!),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          child: IconButton(
            color: Colors.black,
            iconSize: 90,
            onPressed: () async {
              final XFile picture = await cameraController!.takePicture();
              Uint8List pictureByte = await picture.readAsBytes();
              String _base64 = base64.encode(pictureByte);

              final PhotoEntity photoEntity = PhotoEntity(photo: _base64);
              galleryProvider.addPhoto(photoEntity.toMap());

              // ignore: use_build_context_synchronously
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return const Gallery();
              }));
            },
            icon: const Icon(
              Icons.camera,
              color: Colors.white38,
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: IconButton(
            color: Colors.black,
            iconSize: 90,
            onPressed: () async {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return const Gallery();
              }));
            },
            icon: const Icon(
              Icons.collections,
              color: Colors.white38,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _setupCameraController() async {
    // ignore: no_leading_underscores_for_local_identifiers
    List<CameraDescription> _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      if (mounted) {
        setState(() {
          cameras = _cameras;
          cameraController = CameraController(
            _cameras.first,
            ResolutionPreset.max,
          );
        });
      }
    }

    if (cameraController != null && mounted) {
      await cameraController?.initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }
}
