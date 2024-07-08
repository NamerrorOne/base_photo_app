import 'dart:io';

import 'package:gallery_app_test/entities/photo_entity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class GalleryDatabase {
  GalleryDatabase._();

  static final GalleryDatabase db = GalleryDatabase._();

  Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initialize();
    return _database;
  }

  Future<Database> _initialize() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = '${dir.path}/gallery_database';
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  void _createDatabase(Database database, int version) async {
    await database
        .execute('CREATE TABLE Photos(id INTEGER PRIMARY KEY, photo TEXT)');
  }

  Future<List<PhotoEntity>> getAllPhotos() async {
    Database? database = await this.database;
    final List<PhotoEntity> photosList = [];

    final List photosMapList = await database!.query('Photos');
    for (var element in photosMapList) {
      PhotoEntity photoMap = PhotoEntity.fromMap(element);
      photosList.add(photoMap);
    }

    return photosList;
  }

  Future<void> insertPhoto(value) async {
    Database? database = await this.database;
    database!
        .insert('Photos', value, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deletePhoto(int id) async {
    Database? db = await database;
    return db!.delete('Photos', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAllPhoto() async {
    Database? database = await this.database;
    return database!.delete(
      'Photos',
    );
  }
}
