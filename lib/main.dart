import 'package:flutter/material.dart';

import 'package:gallery_app_test/presentation/provider/gallery_provider.dart';
import 'package:gallery_app_test/presentation/screens/camera_view_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MainApp(),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Их было несколько изначально)
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            GalleryProvider galleryProvider = GalleryProvider();
            galleryProvider.initPhotos();
            return galleryProvider;
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: CameraViewScreen(),
      ),
    );
  }
}
