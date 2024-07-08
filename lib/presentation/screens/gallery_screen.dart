import 'dart:convert';

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gallery_app_test/database/gallery_database.dart';

import 'package:gallery_app_test/presentation/provider/gallery_provider.dart';
import 'package:gallery_app_test/presentation/screens/camera_view_screen.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class Gallery extends StatelessWidget {
  const Gallery({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              context.read<GalleryProvider>().deleteAllPhoto();
            },
            child: const Icon(Icons.delete),
          ),
          const SizedBox(
            width: 20,
          ),
          FloatingActionButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const CameraViewScreen();
                  },
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(
                    context.watch<GalleryProvider>().allPhotos.length, (index) {
                  Uint8List bytesImage = const Base64Decoder().convert(
                      context.read<GalleryProvider>().allPhotos[index].photo);

                  XFile xFile = XFile.fromData(bytesImage);

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
                          onLongPress: () {
                            Share.shareXFiles([xFile]);
                          },
                          child: SizedBox(
                            height: 250,
                            width: double.infinity,
                            child: RepaintBoundary(
                              child: Image.memory(
                                bytesImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            top: 0,
                            right: 0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                width: 40,
                                height: 40,
                                color: Colors.white,
                                child: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    context
                                        .read<GalleryProvider>()
                                        .removePhoto(index + 1);
                                  },
                                ),
                              ),
                            )),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
