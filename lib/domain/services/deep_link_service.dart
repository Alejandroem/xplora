abstract class DeepLinkService {
  Stream<String?> get codeStream;

  Future<void> initialize();
  void dispose();
}
