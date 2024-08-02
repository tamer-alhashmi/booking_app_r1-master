import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class StorageService {
  static Future<String?> getImageUrl(String imagePath) async {
    try {
      firebase_storage.Reference ref =
      firebase_storage.FirebaseStorage.instance.ref(imagePath);
      return await ref.getDownloadURL();
    } catch (e) {
      print("Error fetching image URL: $e");
      return null;
    }
  }
}
