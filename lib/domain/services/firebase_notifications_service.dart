abstract class NotificationsService {
  Future<void> saveToken(String userId);
  Future<void> subscribeToTopic(String topic);
  Future<void> unsubscribeFromTopic(String topic);
  Future<void> sendNotificationToTopic(String topic, String title, String body);
  Future<void> sendNotificationToToken(String token, String title, String body);
}
