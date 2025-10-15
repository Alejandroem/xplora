abstract class StorageService {
  Future<String> uploadImage(String filePath, String folderPath);
  Future<void> deleteImage(String imageUrl);
}
