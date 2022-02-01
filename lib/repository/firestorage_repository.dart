import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FireStorageRepository {
  var rnd = Random().nextInt(45) + 1;
  firebase_storage.UploadTask uploadImageFile(String uid, File file, int idx) {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('text/$uid')
        .child('/some-image$idx.jpg');

    return ref.putFile(file);
  }
}
