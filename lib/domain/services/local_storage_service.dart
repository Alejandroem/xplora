abstract class LocalStorageService {
  Future<void> save(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
}
