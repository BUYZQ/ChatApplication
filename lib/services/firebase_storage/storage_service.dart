import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String?> addImage(File file) async {
    try {
      Reference ref = _firebaseStorage.ref().child('images/${DateTime.now().microsecondsSinceEpoch}.png');
      await ref.putFile(file);
      String imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } catch(e) {
      log(e.toString());
    }
    return null;
  }
}