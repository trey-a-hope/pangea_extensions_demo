import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  Future<String> uploadFile({required File file, required String path}) async {
    try {
      final Reference ref = FirebaseStorage.instance.ref().child(path);
      final UploadTask uploadTask = ref.putFile(file);
      final Reference sr = (await uploadTask).ref;
      return (await sr.getDownloadURL()).toString();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
