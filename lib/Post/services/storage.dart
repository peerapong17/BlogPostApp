import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';

class Storage {
  Reference ref = FirebaseStorage.instance
      .ref()
      .child("blog")
      .child("images")
      .child("${randomAlphaNumeric(9)}.jpg");

  UploadTask uploadImage({required File imageFile}) {
    UploadTask task = ref.putFile(imageFile);
    return task;
  }
}
