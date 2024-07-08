import 'package:flutter/material.dart';
import 'package:gallery_app_test/database/gallery_database.dart';
import 'package:gallery_app_test/entities/photo_entity.dart';

class GalleryProvider extends ChangeNotifier {
  List<PhotoEntity> allPhotos = [];

  void initPhotos() async {
    final allPhotosFromDB = await GalleryDatabase.db.getAllPhotos();
    allPhotos = allPhotosFromDB;
    notifyListeners();
  }

  void addPhoto(photo) {
    GalleryDatabase.db.insertPhoto(photo);
    initPhotos();
  }

  void removePhoto(index) {
    GalleryDatabase.db.deletePhoto(index);
    initPhotos();
  }

  void deleteAllPhoto() {
    GalleryDatabase.db.deleteAllPhoto();
    initPhotos();
  }
}
