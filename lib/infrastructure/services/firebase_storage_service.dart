import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

import '../../domain/services/storage_service.dart';

class FirebaseStorageService implements StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Duration _uploadTimeout = const Duration(seconds: 20);

  @override
  Future<String> uploadImage(String filePath, String folderPath) async {
    try {
      final file = File(filePath);

      // Use the folderPath as the filename (which will be the user ID)
      final fileName = folderPath;

      final ref = _storage.ref().child('profile_images/$fileName');

      final uploadTask = ref.putFile(file);
      // await Future.delayed(_uploadTimeout);
      // throw Exception('Upload timed out after ${_uploadTimeout.inSeconds} seconds');
      final snapshot = await uploadTask.timeout(
        _uploadTimeout,
        onTimeout: () {
          uploadTask.cancel();
          throw Exception('Upload timed out after ${_uploadTimeout.inSeconds} seconds');
        },
      );
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  @override
  Future<void> deleteImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }
}
