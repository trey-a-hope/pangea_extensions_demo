import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class StorageService {
  static const String testFileName = 'eicar-test-file.com';

  Future<String> uploadFile({required File file}) async {
    try {
      final Reference ref =
          FirebaseStorage.instance.ref().child(basename(file.path));
      final UploadTask uploadTask = ref.putFile(file);
      final Reference sr = (await uploadTask).ref;
      return (await sr.getDownloadURL()).toString();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
