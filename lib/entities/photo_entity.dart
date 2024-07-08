class PhotoEntity {
  int? id;
  late String photo;

  PhotoEntity({this.id, required this.photo});

  PhotoEntity.fromMap(map) {
    id = map['id'];
    photo = map['photo'];
  }

  Map<String, dynamic> toMap() {
    final photoMap = <String, dynamic>{};
    photoMap['id'] = id;
    photoMap['photo'] = photo;
    return photoMap;
  }
}
