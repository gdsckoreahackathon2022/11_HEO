import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FireStorageRepository {

  // storage에 이미지를 저장
  firebase_storage.UploadTask uploadImageFile(String uid, File file, int idx) {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('text/$uid')
        .child('/some-image$idx.jpg');

    return ref.putFile(file);
  }
}
